// =================================================================
// SECCIÓN 1: ESTADO GLOBAL Y VARIABLES
// =================================================================

// Almacena las traducciones enviadas desde Lua (config.lua)
let globalTranslations = {};

// [IMPORTANTE] Lista MAESTRA con todos los datos. Nunca se filtra, sirve de respaldo.
let originalFullList = [];

// Lista de TRABAJO. Es la que se ordena, filtra y recorta para la paginación.
let currentWorkingList = [];

// Configuración de visualización
let currentPage = 1;           // Página actual
let itemsPerPage = 7;          // Elementos por página (se actualiza desde Lua)
let sortColumn = 'date_added'; // Columna activa de ordenación
let sortDirection = 'desc';    // 'asc' o 'desc'
let currentFilter = '';        // Texto del buscador

// =================================================================
// SECCIÓN 2: SISTEMA DE TRADUCCIÓN Y FORMATO
// =================================================================

function applyTranslations() {
    const elements = document.querySelectorAll('[data-i18n]');

    elements.forEach(el => {
        const key = el.getAttribute('data-i18n');

        // Caso especial: Encabezados de tabla (TH)
        if (el.tagName === 'TH' && globalTranslations[key]) {
            const headerTextSpan = el.querySelector('.header-text');
            if (headerTextSpan) headerTextSpan.innerText = globalTranslations[key];

            // Inyectar iconos de ordenación si no existen
            const sortIconSpan = el.querySelector('.sort-icon');
            if (sortIconSpan) {
                sortIconSpan.innerHTML = '<i class="fa-solid fa-sort-up"></i><i class="fa-solid fa-sort-down"></i><i class="fa-solid fa-sort"></i>';
            }
        }
        // Caso normal: Textos simples, botones, etiquetas
        else if (globalTranslations[key]) {
            el.innerText = globalTranslations[key];
        }
    });

    // Reinicializar listeners de ordenación tras aplicar textos
    initializeSortListeners();
}

// Formateador de dinero (Ej: 50000 -> $50,000)
function formatCurrency(amount) {
    return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD', maximumFractionDigits: 0 }).format(amount);
}

// =================================================================
// SECCIÓN 3: GESTIÓN VISUAL (MENÚ Y MODALES)
// =================================================================

/**
 * Cierra el menú completamente y devuelve el control al juego.
 */
function closeMenu() {
    const container = document.getElementById('container');
    container.style.display = 'none';

    // Avisar a Lua para quitar el cursor (SetNuiFocus false)
    fetch(`https://DP-PdmEscaparates/closeMenu`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        body: JSON.stringify({ message: 'Menu cerrado desde JS' })
    }).catch(err => console.error('Error callback closeMenu:', err));
}

/**
 * Muestra u oculta ventanas emergentes (Modales).
 * @param {string} modalId - ID del div del modal
 * @param {boolean} isVisible - true/false
 */
function toggleModal(modalId, isVisible) {
    const modal = document.getElementById(modalId);
    const menuContainer = document.getElementById('container');

    if (modal) {
        modal.style.display = isVisible ? 'flex' : 'none';
    }

    if (menuContainer) {
        // Efecto de desenfoque (blur) en el fondo
        if (isVisible) {
            menuContainer.classList.add('modal-active');
        } else {
            menuContainer.classList.remove('modal-active');
        }
    }
}

/**
 * Actualiza los inputs de coordenadas en el modal de Crear Spawn.
 */
function updateCoordsDisplay(coords) {
    if (coords && document.getElementById('set-spawn-modal').style.display === 'flex') {
        document.getElementById('coord_x').value = coords.x.toFixed(2);
        document.getElementById('coord_y').value = coords.y.toFixed(2);
        document.getElementById('coord_z').value = coords.z.toFixed(2);
        document.getElementById('coord_h').value = coords.h.toFixed(2);
    }
}

// =================================================================
// SECCIÓN 3.5: GESTIÓN DEL HUD (ETIQUETAS FLOTANTES)
// =================================================================

/**
 * Actualiza las etiquetas flotantes sobre los vehículos.
 * @param {Array} visibleVehicles - Array de objetos {id, x, y, display_name, ...}
 */
function updateShowroomHUD(visibleVehicles) {
    const hudContainer = document.getElementById('hud-container');
    if (!hudContainer) return;

    // Crea un Set con los IDs visibles actuales para saber cuáles borrar
    const currentIds = new Set(visibleVehicles.map(v => v.id));

    // 1. LIMPIEZA: Eliminar etiquetas que ya no están en la lista visible
    Array.from(hudContainer.children).forEach(child => {
        const childId = parseInt(child.getAttribute('data-vehicle-id'));
        if (!currentIds.has(childId)) {
            child.remove();
        }
    });

    // 2. ACTUALIZACIÓN/CREACIÓN: Recorrer vehículos visibles
    visibleVehicles.forEach(veh => {
        let tag = hudContainer.querySelector(`.vehicle-tag[data-vehicle-id="${veh.id}"]`);

        // Si la etiqueta NO existe, crearla
        if (!tag) {
            tag = document.createElement('div');
            tag.className = 'vehicle-tag';
            tag.setAttribute('data-vehicle-id', veh.id);

            // HTML interno de la tarjeta (CON PRECIO)
            tag.innerHTML = `
                <div class="tag-title">${veh.display_name}</div>
                <div class="tag-spot">${veh.spawn_name || 'Sin Posición'}</div>
                <div class="tag-info">Colocado por: <strong>${veh.setter_name}</strong></div>
                <div class="tag-price">${formatCurrency(veh.price || 0)}</div>
            `;
            hudContainer.appendChild(tag);
        }

        // Si la etiqueta YA existe, solo actualiza su posición (style)
        // Las coordenadas x, y vienen de Lua en rango 0.0 a 1.0
        // Multiplica por 100 para obtener porcentaje CSS
        tag.style.left = `${veh.x * 100}%`;
        tag.style.top = `${veh.y * 100}%`;
    });
}


// =================================================================
// SECCIÓN 4: LÓGICA DE DATOS (TABLA Y PAGINACIÓN)
// =================================================================

/**
 * [CORE] Recibe los datos crudos de Lua, guarda el original y prepara la vista.
 */
function populateVehicleTable(vehicleList) {
    originalFullList = vehicleList; // Guardar copia de seguridad

    // Aplicar ordenación por defecto a la lista de trabajo
    currentWorkingList = applySortLogic(originalFullList);

    // Ajustar paginación si pasa de rango
    const totalPages = Math.ceil(currentWorkingList.length / itemsPerPage);
    if (currentPage > totalPages) {
        currentPage = totalPages > 0 ? totalPages : 1;
    }

    displayCurrentPage();
}

/**
 * Renderiza los botones < Anterior | Siguiente >
 */
function renderPaginationControls() {
    const controlsContainer = document.getElementById('pagination-controls');
    controlsContainer.innerHTML = '';

    const totalItems = currentWorkingList.length;
    const totalPages = Math.ceil(totalItems / itemsPerPage);

    if (totalPages <= 1) return; // Si solo hay 1 página, no mostrar controles

    // Botón Anterior
    const prevButton = document.createElement('button');
    prevButton.className = 'page-button';
    prevButton.innerText = '<';
    prevButton.disabled = currentPage === 1;
    prevButton.addEventListener('click', () => {
        if (currentPage > 1) { currentPage--; displayCurrentPage(); }
    });
    controlsContainer.appendChild(prevButton);

    // Texto Central
    const pageCounter = document.createElement('span');
    pageCounter.className = 'current-page';
    pageCounter.innerText = `${currentPage} / ${totalPages}`;
    controlsContainer.appendChild(pageCounter);

    // Botón Siguiente
    const nextButton = document.createElement('button');
    nextButton.className = 'page-button';
    nextButton.innerText = '>';
    nextButton.disabled = currentPage === totalPages;
    nextButton.addEventListener('click', () => {
        if (currentPage < totalPages) { currentPage++; displayCurrentPage(); }
    });
    controlsContainer.appendChild(nextButton);
}

/**
 * Corta la lista y dibuja solo las filas de la página actual.
 */
function displayCurrentPage() {
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    const vehiclesToShow = currentWorkingList.slice(startIndex, endIndex);

    populateVehicleTableRows(vehiclesToShow);
    renderPaginationControls();
}

/**
 * Genera el HTML de las filas de la tabla (<tr>...</tr>).
 */
function populateVehicleTableRows(vehicleList) {
    const tableBody = document.getElementById('vehicle-list');
    tableBody.innerHTML = '';

    // Si no hay datos, mostrar mensaje
    if (currentWorkingList.length === 0) {
        const emptyRow = document.createElement('tr');
        emptyRow.innerHTML = `<td colspan="7" class="no-data-row" data-i18n="no_vehicles">${globalTranslations['no_vehicles'] || 'No hay vehículos.'}</td>`;
        tableBody.appendChild(emptyRow);
        document.getElementById('pagination-controls').innerHTML = '';
        return;
    }

    vehicleList.forEach(vehicle => {
        const row = document.createElement('tr');

        // --- PROCESAMIENTO DE FECHA ---
        let dateTimeDisplay = 'Fecha Inválida';
        try {
            if (vehicle.date_added) {
                let dateString = typeof vehicle.date_added === 'string'
                    ? vehicle.date_added.replace(' ', 'T')
                    : vehicle.date_added;

                const date = new Date(dateString);

                if (!isNaN(date.getTime())) {
                    const formattedDate = date.toLocaleDateString('es-ES');
                    const formattedTime = date.toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit', hour12: false });
                    dateTimeDisplay = `${formattedDate} | ${formattedTime}`;
                }
            }
        } catch (e) { console.error("Error fecha:", e); }

        // --- VISUALIZACIÓN DE COORDENADAS ---
        const coordsDisplay = (vehicle.spawn_name)
            ? vehicle.spawn_name
            : (vehicle.spawn_x ? `${vehicle.spawn_x}, ${vehicle.spawn_y}` : 'No Asignado');

        // --- HTML DE LA FILA (Con Precio) ---
        row.innerHTML = `
            <td>${vehicle.model}</td>
            <td>${vehicle.display_name}</td>
            <td style="white-space: nowrap;">${dateTimeDisplay}</td> 
            <td>${vehicle.setter_name}</td>
            <td>${coordsDisplay}</td>
            <td>${formatCurrency(vehicle.price || 0)}</td>
            <td class="centro">
                <button class="btn-icon edit-vehicle" data-id="${vehicle.id}" title="Editar"><i class="fa-solid fa-pen"></i></button>
                <button class="btn-icon delete-vehicle" data-id="${vehicle.id}" title="Eliminar"><i class="fa-solid fa-trash-can"></i></button>
            </td>
        `;
        tableBody.appendChild(row);
    });

    // Reasignar listeners a los botones generados dinámicamente
    attachRowActionListeners();
}

/**
 * Asigna eventos Click a los botones de Editar y Eliminar de cada fila.
 */
function attachRowActionListeners() {
    // Botones Editar
    document.querySelectorAll('.edit-vehicle').forEach(button => {
        button.addEventListener('click', (event) => {
            const vehicleId = parseInt(event.currentTarget.getAttribute('data-id'));
            openEditModal(vehicleId);
        });
    });

    // Botones Eliminar
    document.querySelectorAll('.delete-vehicle').forEach(button => {
        button.addEventListener('click', (event) => {
            const vehicleId = event.currentTarget.getAttribute('data-id');
            const row = event.currentTarget.closest('tr');
            const vehicleName = row.children[1].innerText; // Columna Nombre

            // Preparar Modal de Confirmación
            const title = globalTranslations['modal_delete_title'] || 'Confirmar';
            const descTemplate = globalTranslations['modal_delete_desc'] || 'Borrar %s?';

            document.getElementById('delete-modal-title').innerText = title;
            document.getElementById('delete-modal-text').innerText = descTemplate.replace('%s', vehicleName);
            document.getElementById('vehicle-to-delete-id').value = vehicleId;

            toggleModal('delete-confirm-modal', true);
        });
    });
}

// =================================================================
// SECCIÓN 5: FILTROS Y ORDENACIÓN
// =================================================================

/**
 * Filtra la lista según lo que escribas en el buscador.
 */
function filterVehicleList() {
    const searchTerm = document.getElementById('vehicle-search-input').value.toLowerCase().trim();
    currentFilter = searchTerm;

    if (!searchTerm) {
        // Resetear si está vacío
        currentWorkingList = applySortLogic(originalFullList);
    } else {
        // Filtrar sobre la lista ORIGINAL
        const filteredList = originalFullList.filter(vehicle => {
            const searchStr = `${vehicle.model} ${vehicle.display_name} ${vehicle.setter_name} ${vehicle.spawn_name}`.toLowerCase();
            return searchStr.includes(searchTerm);
        });
        currentWorkingList = applySortLogic(filteredList);
    }

    currentPage = 1;
    displayCurrentPage();
}

/**
 * Ordena la lista actual (WorkingList) según columna y dirección.
 */
function sortVehicleList() {
    if (currentFilter) {
        filterVehicleList(); // Si hay filtro, reaplicarlo con el nuevo orden
    } else {
        currentWorkingList = applySortLogic(originalFullList);
        currentPage = 1;
        displayCurrentPage();
    }
}

function applySortLogic(listToSort) {
    const key = sortColumn;
    const direction = sortDirection === 'asc' ? 1 : -1;
    const sortedList = [...listToSort]; // Copia para no mutar original

    sortedList.sort((a, b) => {
        let valA = a[key], valB = b[key];

        // Manejo especial para fechas y números
        if (key === 'date_added') {
            valA = new Date(valA).getTime();
            valB = new Date(valB).getTime();
        } else if (key === 'price') {
            valA = parseFloat(valA) || 0;
            valB = parseFloat(valB) || 0;
        } else if (!isNaN(valA) && !isNaN(valB) && key !== 'price') {
            valA = parseFloat(valA);
            valB = parseFloat(valB);
        } else {
            valA = String(valA).toLowerCase();
            valB = String(valB).toLowerCase();
        }

        return (valA < valB ? -1 : 1) * direction;
    });
    return sortedList;
}

// =================================================================
// SECCIÓN 6: FORMULARIOS (EDITAR / SELECTORES)
// =================================================================

function openEditModal(vehicleId) {
    const vehicleData = originalFullList.find(v => v.id === vehicleId);
    if (!vehicleData) return;

    // Rellenar formulario
    document.getElementById('editVehicleId').value = vehicleId;
    document.getElementById('editVehicleDisplayName').value = vehicleData.display_name;
    document.getElementById('editVehicleHash').value = vehicleData.model;
    document.getElementById('editVehiclePrice').value = vehicleData.price || 0; // Cargar precio

    // Copiar opciones del selector principal al de edición
    const spawnSelector = document.getElementById('editSpawnSelector');
    spawnSelector.innerHTML = document.getElementById('spawnSelector').innerHTML;
    spawnSelector.value = vehicleData.spawn_id || 0;

    toggleModal('edit-vehicle-modal', true);
}

function populateSpawnSelector(spawnList) {
    const selector = document.getElementById('spawnSelector');
    const defaultOption = selector.querySelector('option[value="0"]'); // Guardar opción "Ninguno"

    selector.innerHTML = '';
    if (defaultOption) selector.appendChild(defaultOption);

    if (!spawnList || spawnList.length === 0) return;

    spawnList.forEach(spawn => {
        const option = document.createElement('option');
        option.value = spawn.id;
        option.innerText = `${spawn.name} (X: ${Math.round(spawn.x)})`;
        selector.appendChild(option);
    });
}

// =================================================================
// SECCIÓN 7: LISTENERS E INICIALIZACIÓN (DOM READY)
// =================================================================

function initializeSortListeners() {
    document.querySelectorAll('thead th[data-sort-key]').forEach(header => {
        header.addEventListener('click', () => {
            const key = header.getAttribute('data-sort-key');

            // Alternar dirección si es la misma columna
            if (key === sortColumn) {
                sortDirection = (sortDirection === 'asc' ? 'desc' : 'asc');
            } else {
                sortColumn = key;
                sortDirection = 'desc';
            }

            sortVehicleList();
            updateSortHeaders(header);
        });
    });

    // Marcar columna inicial
    const defaultHeader = document.querySelector(`thead th[data-sort-key="${sortColumn}"]`);
    if (defaultHeader) updateSortHeaders(defaultHeader);
}

function updateSortHeaders(activeHeader) {
    document.querySelectorAll('thead th').forEach(h => h.classList.remove('active-sort', 'sort-asc', 'sort-desc'));
    activeHeader.classList.add('active-sort', `sort-${sortDirection}`);
}

// ---- EVENTO PRINCIPAL: CARGA DEL DOM ----
document.addEventListener('DOMContentLoaded', () => {
    const container = document.getElementById('container');

    // 1. Listeners de Botones Principales
    document.querySelector('[data-i18n="btn_set_spawn"]').addEventListener('click', () => toggleModal('set-spawn-modal', true));
    document.querySelector('[data-i18n="btn_assign_vehicle"]').addEventListener('click', () => toggleModal('assign-vehicle-modal', true));

    // Copiar Coordenadas
    document.getElementById('copy-coords-btn').addEventListener('click', () => {
        fetch('https://DP-PdmEscaparates/requestSpawnCoords', { method: 'POST', body: JSON.stringify({}) });
    });

    // Cerrar Modales (X / Cancelar)
    document.querySelectorAll('.modal-close-btn').forEach(btn => {
        btn.addEventListener('click', (e) => toggleModal(e.currentTarget.getAttribute('data-modal'), false));
    });

    // 2. Buscador
    document.getElementById('vehicle-search-input').addEventListener('input', filterVehicleList);

    // 3. Acciones de Formularios (Fetch a Lua)

    // Crear Spawn
    document.getElementById('confirm-spawn-btn').addEventListener('click', () => {
        const name = document.getElementById('spawnName').value.trim();
        const x = parseFloat(document.getElementById('coord_x').value);
        const y = parseFloat(document.getElementById('coord_y').value);
        const z = parseFloat(document.getElementById('coord_z').value);
        const h = parseFloat(document.getElementById('coord_h').value);

        if (!name || isNaN(x)) return; // Validación simple

        fetch('https://DP-PdmEscaparates/setSpawnPosition', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ name, x, y, z, h })
        });
        toggleModal('set-spawn-modal', false);
    });

    // Asignar Vehículo
    document.getElementById('confirm-assign-btn').addEventListener('click', () => {
        const model = document.getElementById('vehicleHash').value.trim();
        if (!model) return;

        // Envia el precio
        fetch('https://DP-PdmEscaparates/assignVehicle', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                display_name: document.getElementById('vehicleDisplayName').value.trim(),
                model: model,
                spawn_id: parseInt(document.getElementById('spawnSelector').value),
                price: parseInt(document.getElementById('vehiclePrice').value) || 0
            })
        });
        toggleModal('assign-vehicle-modal', false);
        document.getElementById('vehicleHash').value = ''; // Limpiar
        document.getElementById('vehiclePrice').value = ''; // Limpiar precio
    });

    // Guardar Edición
    document.getElementById('confirm-edit-btn').addEventListener('click', () => {
        // Envia el precio editado
        fetch('https://DP-PdmEscaparates/editVehicle', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                id: parseInt(document.getElementById('editVehicleId').value),
                display_name: document.getElementById('editVehicleDisplayName').value.trim(),
                model: document.getElementById('editVehicleHash').value.trim(),
                spawn_id: parseInt(document.getElementById('editSpawnSelector').value),
                price: parseInt(document.getElementById('editVehiclePrice').value) || 0
            })
        });
        toggleModal('edit-vehicle-modal', false);
    });

    // Confirmar Borrado
    document.getElementById('confirm-delete-btn').addEventListener('click', () => {
        const id = document.getElementById('vehicle-to-delete-id').value;
        if (id) {
            fetch('https://DP-PdmEscaparates/deleteVehicle', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ id: id })
            });
        }
        toggleModal('delete-confirm-modal', false);
    });

    // 4. Listener de Mensajes NUI (Lua -> JS)
    window.addEventListener('message', (event) => {
        const data = event.data;
        switch (data.action) {
            case 'setVisible':
                container.style.display = data.status ? 'flex' : 'none';
                break;
            case 'loadTranslations':
                globalTranslations = data.translations;
                itemsPerPage = data.itemsPerPage || 7;
                applyTranslations();
                break;
            case 'updateCoords':
                updateCoordsDisplay(data.coords);
                break;
            case 'sendVehicles':
                if (data.vehicleList && Array.isArray(data.vehicleList)) {
                    populateVehicleTable(data.vehicleList);
                }
                break;
            case 'sendSpawns':
                populateSpawnSelector(data.spawnList);
                break;
            // Caso para actualizar el HUD
            case 'updateHUD':
                updateShowroomHUD(data.vehicles);
                break;
        }
    });

    // 5. Tecla ESC
    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape' || event.keyCode === 27) {
            // Si hay un modal abierto, cerrar el modal. Si no, cerrar el menú.
            const modals = ['set-spawn-modal', 'assign-vehicle-modal', 'delete-confirm-modal', 'edit-vehicle-modal'];
            const activeModal = modals.find(id => document.getElementById(id).style.display === 'flex');

            if (activeModal) toggleModal(activeModal, false);
            else closeMenu();
        }
    });
});
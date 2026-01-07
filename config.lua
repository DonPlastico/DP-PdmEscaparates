Config = {}

-- =================================================================
-- SECCIÓN 1: AJUSTES PRINCIPALES (CORE)
-- =================================================================

-- Selección del Framework del servidor.
-- Opciones disponibles:
-- 'qbcore'   -> QBCore Framework (Oficial)
-- 'esx'      -> ESX 1.1 / 1.2 / 1.Final
-- 'new_esx'  -> ESX Legacy (v1.9.0 o superior)
-- 'ox'       -> Ox_Core
-- 'custom'   -> Framework propio (Requiere editar sv_main.lua)
Config.Framework = 'qbcore'

-- Nombre del trabajo (Job) requerido para abrir el menú.
-- Ejemplos: 'cardealer'... el que corresponda a tu job de vendedor de vehículos.
Config.JobName = 'police'

-- Nombre del comando para abrir el menú en el juego.
-- Uso: /pdmescaparate (o lo que pongas aquí)
Config.Command = 'pdmescaparate'

-- =================================================================
-- SECCIÓN 2: AJUSTES DE INTERFAZ Y NOTIFICACIONES
-- =================================================================

-- ¿Mostrar una notificación de error si un jugador SIN trabajo intenta usar el comando?
-- true = Muestra "No tienes permiso". | false = No hace nada (silencioso).
Config.NotifyOnDeny = true

-- =================================================================
-- SECCIÓN 3: LOCALIZACIÓN (IDIOMAS)
-- =================================================================

-- Idioma activo del script. Cambia esto para traducir todo el menú.
-- Opciones: 'es', 'en', 'ru', 'fr', 'de', 'pt', 'ro', 'bg', 'zh-cn', 'th'
Config.Language = 'es'

Config.Locales = {}

-- [ES] ESPAÑOL
Config.Locales['es'] = {
    ['no_permission'] = 'No tienes permiso para usar esto.',
    ['menu_title'] = 'Gestor de Escaparates',
    ['menu_description'] = 'Administra los vehículos que se muestran actualmente en el escaparate.',
    ['btn_set_spawn'] = '+ Establecer Posición',
    ['btn_assign_vehicle'] = '+ Asignar Vehículo',
    ['col_hash'] = 'Hash / ID',
    ['col_name'] = 'Nombre',
    ['col_date'] = 'Fecha',
    ['col_setter'] = 'Colocado por',
    ['col_coords'] = 'Posición',
    ['col_price'] = 'Precio',
    ['col_actions'] = 'Acciones',
    ['no_vehicles'] = 'No hay vehículos en el escaparate.',
    ['modal_delete_title'] = 'Confirmar Eliminación',
    ['modal_delete_desc'] = '¿Estás seguro de que deseas ELIMINAR el vehículo "%s" del escaparate? Esta acción es irreversible.',
    ['btn_confirm_delete'] = 'Sí, Eliminar',
    ['modal_spawn_title'] = 'Establecer Posición de Spawn',
    ['modal_spawn_desc'] = '¿Confirmas que deseas establecer tu posición actual como el punto de spawn del escaparate?',
    ['btn_confirm_spawn'] = 'Confirmar Posición',
    ['modal_assign_title'] = 'Asignar Nuevo Vehículo al Escaparate',
    ['label_hash'] = 'Hash/Nombre del Vehículo:',
    ['btn_confirm_assign'] = 'Asignar Vehículo',
    ['btn_cancel'] = 'Cancelar',
    ['btn_copy_coords'] = 'Copiar Coordenadas',
    ['label_name'] = 'Nombre:',
    ['spawn_saved'] = 'Posición "%s" guardada con éxito.',
    ['error_name_exists'] = 'Error: Ya existe una posición llamada "%s".',
    ['error_data_missing'] = 'Error: Faltan datos obligatorios para guardar la posición.',
    ['label_vehicle_name'] = 'Nombre del Vehículo (Display Name):',
    ['label_spawn_position'] = 'Posición del Escaparate:',
    ['label_price'] = 'Precio ($):',
    ['option_no_spawn'] = 'No Asignar Posición (Selec.)',
    ['placeholder_search'] = 'Buscar vehículo por ID, nombre o posición...',
    ['modal_edit_title'] = 'Editar Vehículo del Escaparate',
    ['btn_save_changes'] = 'Guardar Cambios',
    ['vehicle_updated'] = 'Vehículo %s actualizado con éxito.',
    ['error_vehicle_not_found'] = 'Error: Vehículo no encontrado o sin cambios.'
}

-- [EN] ENGLISH
Config.Locales['en'] = {
    ['no_permission'] = 'You do not have permission to use this.',
    ['menu_title'] = 'Showcase Manager',
    ['menu_description'] = 'Manage vehicles currently displayed in the showcase.',
    ['btn_set_spawn'] = '+ Set Spawn',
    ['btn_assign_vehicle'] = '+ Assign Vehicle',
    ['col_hash'] = 'Hash / ID',
    ['col_name'] = 'Vehicle Name',
    ['col_date'] = 'Placement Date',
    ['col_setter'] = 'Placed by',
    ['col_coords'] = 'Position',
    ['col_price'] = 'Price',
    ['col_actions'] = 'Actions',
    ['no_vehicles'] = 'There are no vehicles in the showcase.',
    ['modal_delete_title'] = 'Confirm Deletion',
    ['modal_delete_desc'] = 'Are you sure you want to DELETE the vehicle "%s" from the showcase? This action is irreversible.',
    ['btn_confirm_delete'] = 'Yes, Delete',
    ['modal_spawn_title'] = 'Set Spawn Position',
    ['modal_spawn_desc'] = 'Do you confirm that you want to set your current position as the showcase spawn point?',
    ['btn_confirm_spawn'] = 'Confirm Position',
    ['modal_assign_title'] = 'Assign New Vehicle to Showcase',
    ['label_hash'] = 'Vehicle Hash/Name:',
    ['btn_confirm_assign'] = 'Assign Vehicle',
    ['btn_cancel'] = 'Cancel',
    ['btn_copy_coords'] = 'Copy Coordinates',
    ['label_name'] = 'Name:',
    ['spawn_saved'] = 'Position "%s" saved successfully.',
    ['error_name_exists'] = 'Error: A position named "%s" already exists.',
    ['error_data_missing'] = 'Error: Required data is missing to save the position.',
    ['label_vehicle_name'] = 'Vehicle Name (Display Name):',
    ['label_spawn_position'] = 'Showcase Position:',
    ['label_price'] = 'Price ($):',
    ['option_no_spawn'] = 'Do Not Assign Position (Select)'
}

-- [RU] RUSSIAN
Config.Locales['ru'] = {
    ['no_permission'] = 'У вас нет разрешения использовать это.',
    ['menu_title'] = 'Менеджер Витрины',
    ['menu_description'] = 'Управление транспортными средствами, которые в данный момент отображаются на витрине.',
    ['btn_set_spawn'] = '+ Установить Точку Спавна',
    ['btn_assign_vehicle'] = '+ Назначить Транспорт',
    ['col_hash'] = 'Хэш / ID',
    ['col_name'] = 'Название Транспорта',
    ['col_date'] = 'Дата Размещения',
    ['col_setter'] = 'Разместил',
    ['col_coords'] = 'Позиция',
    ['col_price'] = 'Цена',
    ['col_actions'] = 'Действия',
    ['no_vehicles'] = 'На витрине нет транспортных средств.',
    ['modal_delete_title'] = 'Подтверждение Удаления',
    ['modal_delete_desc'] = 'Вы уверены, что хотите УДАЛИТЬ транспорт "%s" с витрины? Это действие необратимо.',
    ['btn_confirm_delete'] = 'Да, Удалить',
    ['modal_spawn_title'] = 'Установить Позицию Спавна',
    ['modal_spawn_desc'] = 'Вы подтверждаете, что хотите установить вашу текущую позицию в качестве точки спавна для витрины?',
    ['btn_confirm_spawn'] = 'Подтвердить Позицию',
    ['modal_assign_title'] = 'Назначить Новый Транспорт на Витрину',
    ['label_hash'] = 'Хэш/Название Транспорта:',
    ['btn_confirm_assign'] = 'Назначить Транспорт',
    ['btn_cancel'] = 'Отмена',
    ['btn_copy_coords'] = 'Копировать Координаты',
    ['label_name'] = 'Название:',
    ['spawn_saved'] = 'Позиция "%s" успешно сохранена.',
    ['error_name_exists'] = 'Ошибка: Позиция с названием "%s" уже существует.',
    ['error_data_missing'] = 'Ошибка: Недостаточно обязательных данных для сохранения позиции.',
    ['label_vehicle_name'] = 'Название Транспорта (Отображаемое):',
    ['label_spawn_position'] = 'Позиция Витрины:',
    ['label_price'] = 'Цена ($):',
    ['option_no_spawn'] = 'Не Назначать Позицию (Выб.)'
}

-- [FR] FRENCH
Config.Locales['fr'] = {
    ['no_permission'] = 'Vous n\'avez pas la permission d\'utiliser ceci.',
    ['menu_title'] = 'Gestionnaire de Vitrine',
    ['menu_description'] = 'Gérez les véhicules actuellement affichés dans la vitrine.',
    ['btn_set_spawn'] = '+ Définir le Point de Spawn',
    ['btn_assign_vehicle'] = '+ Attribuer un Véhicule',
    ['col_hash'] = 'Hash / ID',
    ['col_name'] = 'Nom du Véhicule',
    ['col_date'] = 'Date de Placement',
    ['col_setter'] = 'Placé par',
    ['col_coords'] = 'Position',
    ['col_price'] = 'Prix',
    ['col_actions'] = 'Actions',
    ['no_vehicles'] = 'Il n\'y a pas de véhicules dans la vitrine.',
    ['modal_delete_title'] = 'Confirmer la Suppression',
    ['modal_delete_desc'] = 'Êtes-vous sûr de vouloir SUPPRIMER le véhicule "%s" de la vitrine ? Cette action est irréversible.',
    ['btn_confirm_delete'] = 'Oui, Supprimer',
    ['modal_spawn_title'] = 'Définir la Position de Spawn',
    ['modal_spawn_desc'] = 'Confirmez-vous vouloir définir votre position actuelle comme point de spawn de la vitrine?',
    ['btn_confirm_spawn'] = 'Confirmer la Position',
    ['modal_assign_title'] = 'Attribuer un Nouveau Véhicule à la Vitrine',
    ['label_hash'] = 'Hash/Nom du Véhicule :',
    ['btn_confirm_assign'] = 'Attribuer Véhicule',
    ['btn_cancel'] = 'Annuler',
    ['btn_copy_coords'] = 'Copier Coordonnées',
    ['label_name'] = 'Nom :',
    ['spawn_saved'] = 'Position "%s" sauvegardée avec succès.',
    ['error_name_exists'] = 'Erreur : Une position nommée "%s" existe déjà.',
    ['error_data_missing'] = 'Erreur : Des données obligatoires sont manquantes pour sauvegarder la position.',
    ['label_vehicle_name'] = 'Nom du Véhicule (Nom d\'Affichage) :',
    ['label_spawn_position'] = 'Position de la Vitrine :',
    ['label_price'] = 'Prix ($) :',
    ['option_no_spawn'] = 'Ne Pas Attribuer de Position (Sélec.)'
}

-- [DE] GERMAN
Config.Locales['de'] = {
    ['no_permission'] = 'Du hast keine Berechtigung, dies zu verwenden.',
    ['menu_title'] = 'Schaufenster-Manager',
    ['menu_description'] = 'Verwalte die Fahrzeuge, die derzeit im Schaufenster ausgestellt sind.',
    ['btn_set_spawn'] = '+ Spawn-Position Festlegen',
    ['btn_assign_vehicle'] = '+ Fahrzeug Zuweisen',
    ['col_hash'] = 'Hash / ID',
    ['col_name'] = 'Fahrzeugname',
    ['col_date'] = 'Platzierungsdatum',
    ['col_setter'] = 'Platziert von',
    ['col_coords'] = 'Position',
    ['col_price'] = 'Preis',
    ['col_actions'] = 'Aktionen',
    ['no_vehicles'] = 'Es befinden sich keine Fahrzeuge im Schaufenster.',
    ['modal_delete_title'] = 'Löschung Bestätigen',
    ['modal_delete_desc'] = 'Bist du sicher, dass du das Fahrzeug "%s" aus dem Schaufenster ENTFERNEN möchtest? Diese Aktion ist irreversibel.',
    ['btn_confirm_delete'] = 'Ja, Löschen',
    ['modal_spawn_title'] = 'Spawn-Position Festlegen',
    ['modal_spawn_desc'] = 'Bestätigst du, dass du deine aktuelle Position als Spawn-Punkt für das Schaufenster festlegen möchtest?',
    ['btn_confirm_spawn'] = 'Position Bestätigen',
    ['modal_assign_title'] = 'Neues Fahrzeug zum Schaufenster Zuweisen',
    ['label_hash'] = 'Fahrzeug-Hash/Name:',
    ['btn_confirm_assign'] = 'Fahrzeug Zuweisen',
    ['btn_cancel'] = 'Abbrechen',
    ['btn_copy_coords'] = 'Koordinaten Kopieren',
    ['label_name'] = 'Name:',
    ['spawn_saved'] = 'Position "%s" erfolgreich gespeichert.',
    ['error_name_exists'] = 'Fehler: Eine Position mit dem Namen "%s" existiert bereits.',
    ['error_data_missing'] = 'Fehler: Erforderliche Daten zum Speichern der Position fehlen.',
    ['label_vehicle_name'] = 'Fahrzeugname (Anzeigename):',
    ['label_spawn_position'] = 'Schaufenster-Position:',
    ['label_price'] = 'Preis ($):',
    ['option_no_spawn'] = 'Keine Position Zuweisen (Ausw.)'
}

-- [PT] PORTUGUESE
Config.Locales['pt'] = {
    ['no_permission'] = 'Você não tem permissão para usar isto.',
    ['menu_title'] = 'Gerenciador de Vitrine',
    ['menu_description'] = 'Gerencie os veículos atualmente exibidos na vitrine.',
    ['btn_set_spawn'] = '+ Definir Ponto de Spawn',
    ['btn_assign_vehicle'] = '+ Atribuir Veículo',
    ['col_hash'] = 'Hash / ID',
    ['col_name'] = 'Nome do Veículo',
    ['col_date'] = 'Data de Colocação',
    ['col_setter'] = 'Colocado por',
    ['col_coords'] = 'Posição',
    ['col_price'] = 'Preço',
    ['col_actions'] = 'Ações',
    ['no_vehicles'] = 'Não há veículos na vitrine.',
    ['modal_delete_title'] = 'Confirmar Exclusão',
    ['modal_delete_desc'] = 'Tem certeza de que deseja EXCLUIR o veículo "%s" da vitrine? Esta ação é irreversível.',
    ['btn_confirm_delete'] = 'Sim, Excluir',
    ['modal_spawn_title'] = 'Definir Posição de Spawn',
    ['modal_spawn_desc'] = 'Você confirma que deseja definir sua posição atual como o ponto de spawn da vitrine?',
    ['btn_confirm_spawn'] = 'Confirmar Posição',
    ['modal_assign_title'] = 'Atribuir Novo Veículo à Vitrine',
    ['label_hash'] = 'Hash/Nome do Veículo:',
    ['btn_confirm_assign'] = 'Atribuir Veículo',
    ['btn_cancel'] = 'Cancelar',
    ['btn_copy_coords'] = 'Copiar Coordenadas',
    ['label_name'] = 'Nome:',
    ['spawn_saved'] = 'Posição "%s" salva com sucesso.',
    ['error_name_exists'] = 'Erro: Uma posição chamada "%s" já existe.',
    ['error_data_missing'] = 'Erro: Faltam dados obrigatórios para salvar a posição.',
    ['label_vehicle_name'] = 'Nome do Veículo (Nome de Exibição):',
    ['label_spawn_position'] = 'Posição da Vitrine:',
    ['label_price'] = 'Preço ($):',
    ['option_no_spawn'] = 'Não Atribuir Posição (Selec.)'
}

-- [RO] ROMANIAN
Config.Locales['ro'] = {
    ['no_permission'] = 'Nu aveți permisiunea de a folosi aceasta.',
    ['menu_title'] = 'Manager Vitrină',
    ['menu_description'] = 'Gestionați vehiculele afișate în prezent în vitrină.',
    ['btn_set_spawn'] = '+ Setează Punctul de Spawn',
    ['btn_assign_vehicle'] = '+ Atribuie Vehicul',
    ['col_hash'] = 'Hash / ID',
    ['col_name'] = 'Nume Vehicul',
    ['col_date'] = 'Data Plasării',
    ['col_setter'] = 'Plasat de',
    ['col_coords'] = 'Poziție',
    ['col_price'] = 'Preț',
    ['col_actions'] = 'Acțiuni',
    ['no_vehicles'] = 'Nu există vehicule în vitrină.',
    ['modal_delete_title'] = 'Confirmare Ștergere',
    ['modal_delete_desc'] = 'Sunteți sigur că doriți să ȘTERGEȚI vehiculul "%s" din vitrină? Această acțiune este ireversibilă.',
    ['btn_confirm_delete'] = 'Da, Șterge',
    ['modal_spawn_title'] = 'Setează Poziția de Spawn',
    ['modal_spawn_desc'] = 'Confirmați că doriți să setați poziția dvs. actuală ca punct de spawn pentru vitrină?',
    ['btn_confirm_spawn'] = 'Confirmă Poziția',
    ['modal_assign_title'] = 'Atribuie Vehicul Nou Vitrinei',
    ['label_hash'] = 'Hash/Nume Vehicul:',
    ['btn_confirm_assign'] = 'Atribuie Vehicul',
    ['btn_cancel'] = 'Anulează',
    ['btn_copy_coords'] = 'Copiază Coordonatele',
    ['label_name'] = 'Nume:',
    ['spawn_saved'] = 'Poziția "%s" a fost salvată cu succes.',
    ['error_name_exists'] = 'Eroare: O poziție numită "%s" există deja.',
    ['error_data_missing'] = 'Eroare: Lipsesc date obligatorii pentru a salva poziția.',
    ['label_vehicle_name'] = 'Numele Vehiculului (Nume de Afișare):',
    ['label_spawn_position'] = 'Poziția Vitrinei:',
    ['label_price'] = 'Preț ($):',
    ['option_no_spawn'] = 'Nu Atribui Poziție (Sel.)'
}

-- [BG] BULGARIAN
Config.Locales['bg'] = {
    ['no_permission'] = 'Нямате разрешение да използвате това.',
    ['menu_title'] = 'Мениджър на Витрина',
    ['menu_description'] = 'Управлявайте превозните средства, които в момента са изложени на витрината.',
    ['btn_set_spawn'] = '+ Задаване на Точка на Спаун',
    ['btn_assign_vehicle'] = '+ Задаване на Превозно Средство',
    ['col_hash'] = 'Хеш / ID',
    ['col_name'] = 'Име на Превозно Средство',
    ['col_date'] = 'Дата на Поставяне',
    ['col_setter'] = 'Поставено от',
    ['col_coords'] = 'Позиция',
    ['col_price'] = 'Цена',
    ['col_actions'] = 'Действия',
    ['no_vehicles'] = 'На витрината няма превозни средства.',
    ['modal_delete_title'] = 'Потвърдете Изтриването',
    ['modal_delete_desc'] = 'Сигурни ли сте, че искате да ИЗТРИЕТЕ превозното средство "%s" от витрината? Това действие е необратимо.',
    ['btn_confirm_delete'] = 'Да, Изтрий',
    ['modal_spawn_title'] = 'Задаване на Позиция на Спаун',
    ['modal_spawn_desc'] = 'Потвърждавате ли, че искате да зададете текущата си позиция като точка на спаун за витрината?',
    ['btn_confirm_spawn'] = 'Потвърди Позицията',
    ['modal_assign_title'] = 'Задаване на Ново Превозно Средство на Витрината',
    ['label_hash'] = 'Хеш/Име на Превозно Средство:',
    ['btn_confirm_assign'] = 'Задаване на Превозно Средство',
    ['btn_cancel'] = 'Отказ',
    ['btn_copy_coords'] = 'Копиране на Координати',
    ['label_name'] = 'Име:',
    ['spawn_saved'] = 'Позиция "%s" е запазена успешно.',
    ['error_name_exists'] = 'Грешка: Позиция с име "%s" вече съществува.',
    ['error_data_missing'] = 'Грешка: Липсват задължителни данни за запазване на позицията.',
    ['label_vehicle_name'] = 'Име на Превозно Средство (Показвано Име):',
    ['label_spawn_position'] = 'Позиция на Витрината:',
    ['label_price'] = 'Цена ($):',
    ['option_no_spawn'] = 'Не Задавай Позиция (Изб.)'
}

-- [ZH-CN] CHINESE SIMPLIFIED
Config.Locales['zh-cn'] = {
    ['no_permission'] = '您没有使用此功能的权限。',
    ['menu_title'] = '展柜管理器',
    ['menu_description'] = '管理当前在展柜中展示的载具。',
    ['btn_set_spawn'] = '+ 设置生成点',
    ['btn_assign_vehicle'] = '+ 分配载具',
    ['col_hash'] = '哈希 / ID',
    ['col_name'] = '载具名称',
    ['col_date'] = '放置日期',
    ['col_setter'] = '放置者',
    ['col_coords'] = '位置',
    ['col_price'] = '价格',
    ['col_actions'] = '操作',
    ['no_vehicles'] = '展柜中没有载具。',
    ['modal_delete_title'] = '确认删除',
    ['modal_delete_desc'] = '您确定要从展柜中删除载具 "%s" 吗？此操作不可逆。',
    ['btn_confirm_delete'] = '是的，删除',
    ['modal_spawn_title'] = '设置生成位置',
    ['modal_spawn_desc'] = '您确认要将您当前的位置设置为展柜的生成点吗？',
    ['btn_confirm_spawn'] = '确认位置',
    ['modal_assign_title'] = '分配新载具到展柜',
    ['label_hash'] = '载具哈希/名称:',
    ['btn_confirm_assign'] = '分配载具',
    ['btn_cancel'] = '取消',
    ['btn_copy_coords'] = '复制坐标',
    ['label_name'] = '名称:',
    ['spawn_saved'] = '位置 "%s" 保存成功。',
    ['error_name_exists'] = '错误: 名为 "%s" 的位置已存在。',
    ['error_data_missing'] = '错误: 缺少保存位置所需的必填数据。',
    ['label_vehicle_name'] = '载具名称 (显示名称):',
    ['label_spawn_position'] = '展柜位置:',
    ['label_price'] = '价格 ($):',
    ['option_no_spawn'] = '不分配位置 (选择)'
}

-- [TH] THAI
Config.Locales['th'] = {
    ['no_permission'] = 'คุณไม่มีสิทธิ์ใช้งานสิ่งนี้',
    ['menu_title'] = 'ผู้จัดการตู้โชว์',
    ['menu_description'] = 'จัดการยานพาหนะที่แสดงอยู่ในตู้โชว์ในปัจจุบัน',
    ['btn_set_spawn'] = '+ ตั้งค่าจุดเกิด',
    ['btn_assign_vehicle'] = '+ กำหนดยานพาหนะ',
    ['col_hash'] = 'แฮช / ID',
    ['col_name'] = 'ชื่อยานพาหนะ',
    ['col_date'] = 'วันที่จัดวาง',
    ['col_setter'] = 'จัดวางโดย',
    ['col_coords'] = 'ตำแหน่ง',
    ['col_price'] = 'ราคา',
    ['col_actions'] = 'การดำเนินการ',
    ['no_vehicles'] = 'ไม่มีรถในตู้โชว์',
    ['modal_delete_title'] = 'ยืนยันการลบ',
    ['modal_delete_desc'] = 'คุณแน่ใจหรือไม่ว่าต้องการลบยานพาหนะ "%s" ออกจากตู้โชว์? การดำเนินการนี้ไม่สามารถยกเลิกได้',
    ['btn_confirm_delete'] = 'ใช่, ลบ',
    ['modal_spawn_title'] = 'ตั้งค่าตำแหน่งจุดเกิด',
    ['modal_spawn_desc'] = 'คุณยืนยันที่จะตั้งค่าตำแหน่งปัจจุบันของคุณเป็นจุดเกิดของตู้โชว์หรือไม่?',
    ['btn_confirm_spawn'] = 'ยืนยันตำแหน่ง',
    ['modal_assign_title'] = 'กำหนดรถใหม่ให้กับตู้โชว์',
    ['label_hash'] = 'แฮช/ชื่อยานพาหนะ:',
    ['btn_confirm_assign'] = 'กำหนดยานพาหนะ',
    ['btn_cancel'] = 'ยกเลิก',
    ['btn_copy_coords'] = 'คัดลอกพิกัด',
    ['label_name'] = 'ชื่อ:',
    ['spawn_saved'] = 'บันทึกตำแหน่ง "%s" สำเร็จแล้ว',
    ['error_name_exists'] = 'ข้อผิดพลาด: ตำแหน่งชื่อ "%s" มีอยู่แล้ว',
    ['error_data_missing'] = 'ข้อผิดพลาด: ข้อมูลที่จำเป็นสำหรับการบันทึกตำแหน่งหายไป',
    ['label_vehicle_name'] = 'ชื่อยานพาหนะ (ชื่อที่แสดง):',
    ['label_spawn_position'] = 'ตำแหน่งตู้โชว์:',
    ['label_price'] = 'ราคา ($):',
    ['option_no_spawn'] = 'ไม่กำหนดตำแหน่ง (เลือก)'
}

-- =================================================================
-- FUNCIONES DE UTILIDAD (NO EDITAR)
-- =================================================================

-- Función interna para traducir textos (usada por Client y Server)
_L = function(str, ...)
    if not Config.Locales[Config.Language] then
        return 'LANGUAGE_ERROR'
    end
    if not Config.Locales[Config.Language][str] then
        return str
    end
    return (string.format(Config.Locales[Config.Language][str], ...))
end

import 'package:flutter/foundation.dart';

/// An icon from the bundled SVG set (Material Symbols Rounded, weight 400,
/// grade 0, 24dp). Render it with `MonAIIcon`.
@immutable
final class MonAIIconData {
  const MonAIIconData._(this.name);

  /// The Material Symbols name, e.g. `receipt_long`.
  final String name;

  /// The SVG asset path.
  String get assetPath => 'assets/icons/$name.svg';

  @override
  bool operator ==(Object other) =>
      other is MonAIIconData && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'MonAIIconData($name)';
}

/// Every icon the design uses. `*Filled` variants are for the selected
/// navigation item.
///
/// To add one: download `<name>_24px.svg` (or `<name>_fill1_24px.svg`) from
/// google/material-design-icons `symbols/web/<name>/materialsymbolsrounded/`,
/// save it as `assets/icons/<name>.svg` and add a constant here and to [all].
abstract final class MonAIIcons {
  static const accountBalance = MonAIIconData._('account_balance');
  static const accountBalanceWallet = MonAIIconData._('account_balance_wallet');
  static const accountBalanceWalletFilled = MonAIIconData._(
    'account_balance_wallet_filled',
  );
  static const add = MonAIIconData._('add');
  static const addPhotoAlternate = MonAIIconData._('add_photo_alternate');
  static const adminPanelSettings = MonAIIconData._('admin_panel_settings');
  static const apps = MonAIIconData._('apps');
  static const arrowBack = MonAIIconData._('arrow_back');
  static const arrowForward = MonAIIconData._('arrow_forward');
  static const attachFile = MonAIIconData._('attach_file');
  static const autoAwesome = MonAIIconData._('auto_awesome');
  static const backspace = MonAIIconData._('backspace');
  static const block = MonAIIconData._('block');
  static const bolt = MonAIIconData._('bolt');
  static const calendarMonth = MonAIIconData._('calendar_month');
  static const calendarToday = MonAIIconData._('calendar_today');
  static const category = MonAIIconData._('category');
  static const centerFocusStrong = MonAIIconData._('center_focus_strong');
  static const check = MonAIIconData._('check');
  static const checkCircle = MonAIIconData._('check_circle');
  static const checkroom = MonAIIconData._('checkroom');
  static const chevronLeft = MonAIIconData._('chevron_left');
  static const chevronRight = MonAIIconData._('chevron_right');
  static const close = MonAIIconData._('close');
  static const cloudOff = MonAIIconData._('cloud_off');
  static const cropFree = MonAIIconData._('crop_free');
  static const darkMode = MonAIIconData._('dark_mode');
  static const delete = MonAIIconData._('delete');
  static const devices = MonAIIconData._('devices');
  static const directionsCar = MonAIIconData._('directions_car');
  static const documentScanner = MonAIIconData._('document_scanner');
  static const download = MonAIIconData._('download');
  static const edit = MonAIIconData._('edit');
  static const editNote = MonAIIconData._('edit_note');
  static const error = MonAIIconData._('error');
  static const expandMore = MonAIIconData._('expand_more');
  static const favorite = MonAIIconData._('favorite');
  static const filterAltOff = MonAIIconData._('filter_alt_off');
  static const fitnessCenter = MonAIIconData._('fitness_center');
  static const flashOff = MonAIIconData._('flash_off');
  static const flashOn = MonAIIconData._('flash_on');
  static const help = MonAIIconData._('help');
  static const history = MonAIIconData._('history');
  static const home = MonAIIconData._('home');
  static const homeFilled = MonAIIconData._('home_filled');
  static const hourglassTop = MonAIIconData._('hourglass_top');
  static const image = MonAIIconData._('image');
  static const info = MonAIIconData._('info');
  static const inventory2 = MonAIIconData._('inventory_2');
  static const lightMode = MonAIIconData._('light_mode');
  static const localCafe = MonAIIconData._('local_cafe');
  static const localGroceryStore = MonAIIconData._('local_grocery_store');
  static const lock = MonAIIconData._('lock');
  static const lockClock = MonAIIconData._('lock_clock');
  static const logout = MonAIIconData._('logout');
  static const lunchDining = MonAIIconData._('lunch_dining');
  static const mail = MonAIIconData._('mail');
  static const moreVert = MonAIIconData._('more_vert');
  static const movie = MonAIIconData._('movie');
  static const northEast = MonAIIconData._('north_east');
  static const offlineBolt = MonAIIconData._('offline_bolt');
  static const payments = MonAIIconData._('payments');
  static const person = MonAIIconData._('person');
  static const personRemove = MonAIIconData._('person_remove');
  static const pets = MonAIIconData._('pets');
  static const photoCamera = MonAIIconData._('photo_camera');
  static const photoLibrary = MonAIIconData._('photo_library');
  static const public = MonAIIconData._('public');
  static const radioButtonChecked = MonAIIconData._('radio_button_checked');
  static const radioButtonUnchecked = MonAIIconData._('radio_button_unchecked');
  static const receiptLong = MonAIIconData._('receipt_long');
  static const receiptLongFilled = MonAIIconData._('receipt_long_filled');
  static const redeem = MonAIIconData._('redeem');
  static const refresh = MonAIIconData._('refresh');
  static const restartAlt = MonAIIconData._('restart_alt');
  static const restaurant = MonAIIconData._('restaurant');
  static const rotate90DegreesCcw = MonAIIconData._('rotate_90_degrees_ccw');
  static const savings = MonAIIconData._('savings');
  static const school = MonAIIconData._('school');
  static const search = MonAIIconData._('search');
  static const searchOff = MonAIIconData._('search_off');
  static const sell = MonAIIconData._('sell');
  static const settings = MonAIIconData._('settings');
  static const settingsFilled = MonAIIconData._('settings_filled');
  static const shield = MonAIIconData._('shield');
  static const shoppingBag = MonAIIconData._('shopping_bag');
  static const south = MonAIIconData._('south');
  static const southWest = MonAIIconData._('south_west');
  static const sportsEsports = MonAIIconData._('sports_esports');
  static const swapHoriz = MonAIIconData._('swap_horiz');
  static const syncAlt = MonAIIconData._('sync_alt');
  static const translate = MonAIIconData._('translate');
  static const twoWheeler = MonAIIconData._('two_wheeler');
  static const unarchive = MonAIIconData._('unarchive');
  static const visibility = MonAIIconData._('visibility');
  static const visibilityOff = MonAIIconData._('visibility_off');
  static const warning = MonAIIconData._('warning');
  static const work = MonAIIconData._('work');
  static const zoomIn = MonAIIconData._('zoom_in');
  static const zoomOut = MonAIIconData._('zoom_out');

  /// Every icon above, for galleries and asset checks.
  static const all = [
    accountBalance,
    accountBalanceWallet,
    accountBalanceWalletFilled,
    add,
    addPhotoAlternate,
    adminPanelSettings,
    apps,
    arrowBack,
    arrowForward,
    attachFile,
    autoAwesome,
    backspace,
    block,
    bolt,
    calendarMonth,
    calendarToday,
    category,
    centerFocusStrong,
    check,
    checkCircle,
    checkroom,
    chevronLeft,
    chevronRight,
    close,
    cloudOff,
    cropFree,
    darkMode,
    delete,
    devices,
    directionsCar,
    documentScanner,
    download,
    edit,
    editNote,
    error,
    expandMore,
    favorite,
    filterAltOff,
    fitnessCenter,
    flashOff,
    flashOn,
    help,
    history,
    home,
    homeFilled,
    hourglassTop,
    image,
    info,
    inventory2,
    lightMode,
    localCafe,
    localGroceryStore,
    lock,
    lockClock,
    logout,
    lunchDining,
    mail,
    moreVert,
    movie,
    northEast,
    offlineBolt,
    payments,
    person,
    personRemove,
    pets,
    photoCamera,
    photoLibrary,
    public,
    radioButtonChecked,
    radioButtonUnchecked,
    receiptLong,
    receiptLongFilled,
    redeem,
    refresh,
    restartAlt,
    restaurant,
    rotate90DegreesCcw,
    savings,
    school,
    search,
    searchOff,
    sell,
    settings,
    settingsFilled,
    shield,
    shoppingBag,
    south,
    southWest,
    sportsEsports,
    swapHoriz,
    syncAlt,
    translate,
    twoWheeler,
    unarchive,
    visibility,
    visibilityOff,
    warning,
    work,
    zoomIn,
    zoomOut,
  ];
}

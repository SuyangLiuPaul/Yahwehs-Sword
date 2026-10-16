/// The one place the two apps differ in how they store add-ons.
///
/// Sword's first importer (bwh47) wrote to the IndexedDB database
/// `seeksparks_versions`, and readers already have Bibles in it. The add-on
/// store opens the SAME database (version 2, which only adds the manifest) so
/// those imports survive the upgrade; `AddonRegistry.restore` carries them
/// over into the manifest the first time it runs.
library;

/// IndexedDB database name (web only).
const String kAddonDbName = 'seeksparks_versions';

/// Folder name under the app-support directory (native only).
const String kAddonDirName = 'addons';

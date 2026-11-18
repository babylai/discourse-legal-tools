import { action } from "@ember/object";
import { exportUserArchive } from "discourse/lib/export-csv";
import { withPluginApi } from "discourse/lib/plugin-api";
import { i18n } from "discourse-i18n";

export default {
  name: "legal-edits",

  initialize() {
    withPluginApi((api) => {
      const siteSettings = api.container.lookup("service:site-settings");

      // The template binds `@controller.exportUserArchive` directly, so only an
      // override of the native `@action` takes effect (not the `actions` hash).
      api.modifyClass(
        "controller:preferences/account",
        (Superclass) =>
          class extends Superclass {
            @action
            exportUserArchive() {
              if (!siteSettings.legal_extended_user_download) {
                return super.exportUserArchive(...arguments);
              }

              this.dialog.yesNoConfirm({
                message: i18n("user.download_archive.confirm_all"),
                didConfirm: () => exportUserArchive(),
              });
            }
          }
      );
    });
  },
};

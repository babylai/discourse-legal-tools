import Component from "@glimmer/component";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { exportEntity } from "discourse/lib/export-csv";
import DButton from "discourse/ui-kit/d-button";
import { i18n } from "discourse-i18n";

export default class DownloadAllWrapper extends Component {
  @service currentUser;
  @service dialog;
  @service siteSettings;

  get showAdminUserExport() {
    switch (this.siteSettings.legal_extended_user_download_admin) {
      case "admins_only":
        return !!this.currentUser?.admin;
      case "admins_and_staff":
        return !!this.currentUser?.staff;
      default:
        return false;
    }
  }

  @action
  exportAdminUserArchive() {
    const user = this.args.outletArgs.model;

    this.dialog.confirm({
      message: i18n("user.download_archive.confirm_all_admin", {
        username: user.username,
      }),
      didConfirm: () => {
        exportEntity("admin_user_archive", { user_id: user.id });
      },
    });
  }

  <template>
    {{#if this.showAdminUserExport}}
      <DButton
        class="btn-default legal-tools-admin-user-archive"
        @action={{this.exportAdminUserArchive}}
        @icon="download"
        @label="user.download_archive.button_text"
      />
    {{/if}}
  </template>
}

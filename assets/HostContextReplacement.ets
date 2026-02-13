import common from '@ohos.app.ability.common';

@Entry
@Component
struct HostContextReplacement {
  build() {
    Button('Get Context')
      .onClick(() => {
        // Modern usage: getUIContext().getHostContext()
        let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
        console.info(`Bundle name: ${context.abilityInfo.bundleName}`);
      })
  }
}

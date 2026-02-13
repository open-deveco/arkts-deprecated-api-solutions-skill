import { UIAbility, common, Want, AbilityConstant } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

export default class FrameworkMigrationAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
    
    // Modern usage: context is available as this.context
    // No need for featureAbility.getContext()
    let context = this.context;
  }
}

@Component
struct AbilityMigrationComponent {
  build() {
    Button('Start Ability')
      .onClick(() => {
        // Modern usage in Component: this.getUIContext().getHostContext()
        const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
        let want: Want = {
          bundleName: 'com.example.app',
          abilityName: 'EntryAbility'
        };
        context.startAbility(want).then(() => {
          hilog.info(0x0000, 'testTag', 'Start Ability success');
        }).catch((err: object) => {
          hilog.error(0x0000, 'testTag', 'Start Ability failed: %{public}s', JSON.stringify(err));
        });
      })
  }
}

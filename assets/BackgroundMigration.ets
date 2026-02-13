import { backgroundTaskManager } from '@kit.BackgroundTasksKit';
import { wantAgent, WantAgent } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct BackgroundMigration {
  startTask() {
    // getContext is deprecated, use this.getUIContext().getHostContext() as common.UIAbilityContext
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    
    const wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [
        {
          bundleName: 'com.example.app',
          abilityName: 'EntryAbility'
        }
      ],
      operationType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
    };

    wantAgent.getWantAgent(wantAgentInfo).then((wantAgentObj: WantAgent) => {
      // Modern usage: backgroundTaskManager.startBackgroundRunning
      backgroundTaskManager.startBackgroundRunning(context,
        backgroundTaskManager.BackgroundMode.LOCATION, wantAgentObj)
        .then(() => {
          console.info('Operation startBackgroundRunning succeeded');
        })
        .catch((err: BusinessError) => {
          console.error(`Operation startBackgroundRunning failed Cause: ${err.code}`);
        });
    });
  }

  build() {
    Column() {
      Button('Start Background Task')
        .onClick(() => this.startTask())
    }
  }
}

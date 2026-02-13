import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0xFF00;
const TAG = 'GlobalThisReplacement';

@Entry
@Component
struct GlobalThisReplacement {
  @State message: string = 'Hello World';
  @State appStorageMessage: string = 'AppStorage Message';

  showToastViaUIContext() {
    try {
      this.getUIContext().getPromptAction().showToast({
        message: this.message,
        duration: 2000
      });
      hilog.info(DOMAIN, TAG, 'Toast shown via UIContext');
    } catch (err) {
      hilog.error(DOMAIN, TAG, 'Failed to show toast: %{public}s', JSON.stringify(err));
    }
  }

  saveToAppStorage() {
    AppStorage.setOrCreate('appMessage', this.appStorageMessage);
    hilog.info(DOMAIN, TAG, 'Message saved to AppStorage');
  }

  build() {
    Column() {
      Text('globalThis 替代方案示例')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 })

      Text('方案1：使用 UIContext（推荐）')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 })

      Text('在组件内部使用 getUIContext() 获取 UI 上下文')
        .fontSize(12)
        .fontColor('#666666')
        .margin({ bottom: 10 })

      Button('通过 UIContext 显示 Toast')
        .onClick(() => {
          this.showToastViaUIContext();
        })
        .margin({ bottom: 20 })

      Text('方案2：使用 AppStorage')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 })

      TextInput({ placeholder: '输入消息', text: this.appStorageMessage })
        .onChange((value: string) => {
          this.appStorageMessage = value;
        })
        .margin({ bottom: 10 })

      Button('保存到 AppStorage')
        .onClick(() => {
          this.saveToAppStorage();
        })
        .margin({ bottom: 20 })

      Text('说明:')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 10 })

      Text('• globalThis 已被弃用，不再推荐使用')
        .fontSize(12)
        .fontColor('#666666')
        .margin({ bottom: 5 })

      Text('• 使用 getUIContext() 获取组件的 UI 上下文')
        .fontSize(12)
        .fontColor('#666666')
        .margin({ bottom: 5 })

      Text('• 使用 AppStorage 进行跨组件状态共享')
        .fontSize(12)
        .fontColor('#666666')
        .margin({ bottom: 5 })

      Text('• 使用 LocalStorage 进行页面级状态管理')
        .fontSize(12)
        .fontColor('#666666')
        .margin({ bottom: 5 })

      Text('• 在回调或事件处理中通过参数传递 Context')
        .fontSize(12)
        .fontColor('#666666')
    }
    .width('100%')
    .height('100%')
    .padding(20)
  }
}

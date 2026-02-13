import { window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct WindowFocusableMigration {
  @State isFocusable: boolean = true;
  @State message: string = '窗口可聚焦';

  async aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    await this.checkWindowFocusable(context);
  }

  private async checkWindowFocusable(context: common.UIAbilityContext) {
    try {
      const win = await window.getLastWindow(context);
      const properties = win.getWindowProperties();
      this.message = properties.focusable ? '窗口可聚焦' : '窗口不可聚焦';
    } catch (err) {
      console.error('获取窗口属性失败:', err);
    }
  }

  private async setWindowFocusable(context: common.UIAbilityContext, focusable: boolean) {
    try {
      const win = await window.getLastWindow(context);
      
      await win.setWindowFocusable(focusable);
      
      this.isFocusable = focusable;
      this.message = focusable ? '窗口可聚焦' : '窗口不可聚焦';
      
      console.info(`设置窗口可聚焦: ${focusable}`);
    } catch (err) {
      console.error('设置窗口可聚焦失败:', err);
    }
  }

  build() {
    Column() {
      Text('setFocusable API 迁移示例')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      Text(this.message)
        .fontSize(16)
        .fontColor('#333333')
        .margin({ bottom: 20 })

      Button(this.isFocusable ? '设置为不可聚焦' : '设置为可聚焦')
        .fontSize(16)
        .padding({ left: 20, right: 20, top: 10, bottom: 10 })
        .onClick(() => {
          const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
          this.setWindowFocusable(context, !this.isFocusable);
        })

      Column({ space: 12 }) {
        Text('迁移说明:')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
          .fontColor('#666666')

        Text('❌ 旧 API (已弃用):')
          .fontSize(12)
          .fontColor('#999999')
        
        Text('win.setFocusable(focusable)')
          .fontSize(12)
          .fontColor('#FF5722')
          .fontFamily('monospace')
          .padding(8)
          .backgroundColor('#FFF3E0')
          .borderRadius(4)

        Text('✅ 新 API (推荐):')
          .fontSize(12)
          .fontColor('#999999')

        Text('await win.setWindowFocusable(focusable)')
          .fontSize(12)
          .fontColor('#4CAF50')
          .fontFamily('monospace')
          .padding(8)
          .backgroundColor('#E8F5E9')
          .borderRadius(4)
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .alignItems(HorizontalAlign.Center)
  }
}

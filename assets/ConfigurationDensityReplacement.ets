import { display } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

const DOMAIN = 0xFF00;
const TAG = 'ConfigurationDensityReplacement';

@Entry
@Component
struct ConfigurationDensityReplacement {
  @State densityInfo: string = '';
  @State windowInfo: string = '';

  aboutToAppear() {
    this.updateDensityInfo();
    this.updateWindowInfo();
  }

  updateDensityInfo() {
    try {
      const displayInfo = display.getDefaultDisplaySync();
      this.densityInfo = [
        `屏幕密度: ${displayInfo.densityDPI} DPI`,
        `屏幕宽度: ${displayInfo.width} px`,
        `屏幕高度: ${displayInfo.height} px`,
        `刷新率: ${displayInfo.refreshRate} Hz`
      ].join('\n');
      hilog.info(DOMAIN, TAG, 'Density info updated');
    } catch (err) {
      hilog.error(DOMAIN, TAG, 'Failed to get density info: %{public}s', 
        JSON.stringify(err));
      this.densityInfo = '获取屏幕信息失败';
    }
  }

  updateWindowInfo() {
    try {
      const uiAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
      window.getLastWindow(uiAbilityContext, (err, windowClass) => {
        if (err) {
          hilog.error(DOMAIN, TAG, 'Failed to get last window: %{public}s', 
            JSON.stringify(err));
          this.windowInfo = '获取窗口信息失败';
          return;
        }
        const windowProperties = windowClass.getWindowProperties();
        this.windowInfo = [
          `窗口宽度: ${windowProperties.windowRect.width} px`,
          `窗口高度: ${windowProperties.windowRect.height} px`,
          `窗口位置: (${windowProperties.windowRect.left}, ${windowProperties.windowRect.top})`
        ].join('\n');
        hilog.info(DOMAIN, TAG, 'Window info updated');
      });
    } catch (err) {
      hilog.error(DOMAIN, TAG, 'Failed to get window info: %{public}s', 
        JSON.stringify(err));
      this.windowInfo = '获取窗口信息失败';
    }
  }

  convertPxToVp() {
    try {
      const pxValue = 100;
      const vpValue = this.getUIContext().px2vp(pxValue);
      this.getUIContext().getPromptAction().showToast({
        message: `${pxValue}px = ${vpValue}vp`,
        duration: 2000
      });
      hilog.info(DOMAIN, TAG, 'Converted %{public}d px to %{public}f vp', 
        pxValue, vpValue);
    } catch (err) {
      hilog.error(DOMAIN, TAG, 'Failed to convert px to vp: %{public}s', 
        JSON.stringify(err));
    }
  }

  build() {
    Column() {
      Text('Configuration densityDpi 替代方案示例')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 20 })

      Text('方案1：使用 Display API（推荐）')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 })

      Text('使用 @ohos.display 模块获取屏幕信息')
        .fontSize(12)
        .fontColor('#666666')
        .margin({ bottom: 10 })

      Text(this.densityInfo)
        .fontSize(12)
        .fontColor('#666666')
        .textAlign(TextAlign.Start)
        .padding(15)
        .backgroundColor('#F5F5F5')
        .borderRadius(8)
        .margin({ bottom: 20 })

      Text('方案2：使用 WindowProperties')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 })

      Text('通过窗口属性获取屏幕密度相关信息')
        .fontSize(12)
        .fontColor('#666666')
        .margin({ bottom: 10 })

      Text(this.windowInfo)
        .fontSize(12)
        .fontColor('#666666')
        .textAlign(TextAlign.Start)
        .padding(15)
        .backgroundColor('#F5F5F5')
        .borderRadius(8)
        .margin({ bottom: 20 })

      Text('方案3：使用 px2vp 进行转换')
        .fontSize(16)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 })

      Button('转换 100px 到 vp')
        .onClick(() => {
          this.convertPxToVp();
        })
        .margin({ bottom: 20 })

      Text('说明:')
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 10 })

      Text('• Configuration.densityDpi 已被移除')
        .fontSize(12)
        .fontColor('#666666')
        .margin({ bottom: 5 })

      Text('• 使用 display.getDefaultDisplaySync() 获取屏幕信息')
        .fontSize(12)
        .fontColor('#666666')
        .margin({ bottom: 5 })

      Text('• 使用 windowProperties 获取窗口属性')
        .fontSize(12)
        .fontColor('#666666')
        .margin({ bottom: 5 })

      Text('• 使用 getUIContext().px2vp() 进行单位转换')
        .fontSize(12)
        .fontColor('#666666')
    }
    .width('100%')
    .height('100%')
    .padding(20)
  }
}

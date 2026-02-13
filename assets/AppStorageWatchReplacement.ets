import { hilog } from '@kit.PerformanceAnalysisKit';
import { common } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';

const DOMAIN = 0xFF00;
const TAG = 'AppStorageWatchReplacement';

@Entry
@Component
struct AppStorageWatchReplacement {
  @StorageLink('windowWidth') windowWidth: number = 0;
  @StorageLink('deviceType') deviceType: string = 'unknown';
  @StorageLink('sidebarVisible') sidebarVisible: boolean = false;

  updateDeviceInfo() {
    try {
      const uiAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
      window.getLastWindow(uiAbilityContext, (err, windowClass) => {
        if (err) {
          hilog.error(DOMAIN, TAG, 'Failed to get last window: %{public}s', 
            JSON.stringify(err));
          return;
        }
        const windowProperties = windowClass.getWindowProperties();
        const width = windowProperties.windowRect.width;
        
        this.windowWidth = width;
        this.deviceType = width >= 840 ? 'Tablet' : 'Phone';
        this.sidebarVisible = width >= 840;
        
        hilog.info(DOMAIN, TAG, 'Device info updated: width=%{public}d, type=%{public}s', 
          width, this.deviceType);
      });
    } catch (err) {
      hilog.error(DOMAIN, TAG, 'Failed to update device info: %{public}s', 
        JSON.stringify(err));
    }
  }

  toggleSidebar() {
    this.sidebarVisible = !this.sidebarVisible;
    hilog.info(DOMAIN, TAG, 'Sidebar toggled: %{public}s', 
      this.sidebarVisible ? 'visible' : 'hidden');
  }

  build() {
    Row() {
      if (this.sidebarVisible) {
        Column() {
          Text('侧边栏')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .margin(12)

          Text('仅在平板设备上显示')
            .fontSize(12)
            .fontColor('#666666')
            .margin({ left: 12, right: 12, bottom: 12 })

          Button('切换侧边栏')
            .onClick(() => {
              this.toggleSidebar();
            })
            .margin({ left: 12, right: 12, bottom: 12 })
        }
        .width(240)
        .height('100%')
        .backgroundColor($r('app.color.sidebar_background'))
      }

      Column() {
        Text('AppStorage 响应式绑定示例')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20, bottom: 20 })

        Text('方案1：使用 @StorageLink（推荐）')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 10 })

        Text('@StorageLink 会自动监听 AppStorage 中的数据变化')
          .fontSize(12)
          .fontColor('#666666')
          .margin({ bottom: 10 })

        Text(`窗口宽度: ${this.windowWidth}vp`)
          .fontSize(16)
          .margin(20)

        Text(`设备类型: ${this.deviceType}`)
          .fontSize(16)
          .margin(20)

        Text(`侧边栏状态: ${this.sidebarVisible ? '显示' : '隐藏'}`)
          .fontSize(16)
          .margin(20)

        Button('更新设备信息')
          .onClick(() => {
            this.updateDeviceInfo();
          })
          .margin(20)

        Text('说明:')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 20, bottom: 10 })

        Text('• AppStorage.watch() 已被弃用')
          .fontSize(12)
          .fontColor('#666666')
          .margin({ bottom: 5 })

        Text('• 使用 @StorageLink 实现双向绑定')
          .fontSize(12)
          .fontColor('#666666')
          .margin({ bottom: 5 })

        Text('• 使用 @StorageProp 实现单向绑定')
          .fontSize(12)
          .fontColor('#666666')
          .margin({ bottom: 5 })

        Text('• 装饰器会自动处理数据变化监听')
          .fontSize(12)
          .fontColor('#666666')
          .margin({ bottom: 5 })

        Text('• 无需手动管理监听器生命周期')
          .fontSize(12)
          .fontColor('#666666')
      }
      .layoutWeight(1)
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}

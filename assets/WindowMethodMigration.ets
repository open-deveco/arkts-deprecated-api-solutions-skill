import { window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct WindowMethodMigration {
  @State isFullScreen: boolean = false;
  @State statusBarColor: string = '#00000000';
  @State navBarColor: string = '#00000000';

  async aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    
    window.getLastWindow(context, (err, win) => {
      if (err.code !== 0) {
        console.error('获取窗口失败:', err);
        return;
      }
      
      this.setWindowFullScreen(win);
    });
  }

  private async setWindowFullScreen(win: window.Window) {
    try {
      await win.setWindowLayoutFullScreen(true);
      await win.setWindowSystemBarProperties({
        statusBarColor: '#00000000',
        navigationBarColor: '#00000000',
        isStatusBarLightIcon: false,
        isNavigationBarLightIcon: false,
        statusBarContentColor: '#FF000000',
        navigationBarContentColor: '#FF000000'
      });
      this.isFullScreen = true;
      console.info('设置全屏成功');
    } catch (err) {
      console.error('设置全屏失败:', err);
    }
  }

  private async setWindowNormal(win: window.Window) {
    try {
      await win.setWindowLayoutFullScreen(false);
      await win.setWindowSystemBarProperties({
        statusBarColor: '#FFFFFFFF',
        navigationBarColor: '#FFFFFFFF',
        isStatusBarLightIcon: true,
        isNavigationBarLightIcon: true
      });
      this.isFullScreen = false;
      console.info('取消全屏成功');
    } catch (err) {
      console.error('取消全屏失败:', err);
    }
  }

  build() {
    Column() {
      Text(`全屏状态: ${this.isFullScreen}`)
      Button(this.isFullScreen ? '取消全屏' : '设置全屏')
        .onClick(() => {
          const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
          window.getLastWindow(context, (err, win) => {
            if (err.code !== 0) {
              console.error('获取窗口失败:', err);
              return;
            }
            if (this.isFullScreen) {
              this.setWindowNormal(win);
            } else {
              this.setWindowFullScreen(win);
            }
          });
        })
    }
  }
}

import { window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct WindowMigration {
  @State windowWidth: number = 0;

  aboutToAppear() {
    try {
      const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      
      window.getLastWindow(context, (err, win) => {
        if (err.code !== 0) {
          console.error('获取窗口信息失败:', err);
          return;
        }
        
        const properties = win.getWindowProperties();
        this.windowWidth = properties.windowRect.width;
        
        win.on('windowSizeChange', (size: window.Size) => {
          this.windowWidth = size.width;
        });
      });
    } catch (err) {
      console.error('获取上下文失败:', err);
    }
  }

  build() {
    Column() {
      Text(`Window Width: ${this.windowWidth}`)
    }
  }
}

import { window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct AvoidAreaMigration {
  @State avoidArea: window.AvoidArea = {
    topRect: { left: 0, top: 0, width: 0, height: 0 },
    bottomRect: { left: 0, top: 0, width: 0, height: 0 },
    leftRect: { left: 0, top: 0, width: 0, height: 0 },
    rightRect: { left: 0, top: 0, width: 0, height: 0 },
    visible: false
  };
  @State systemAvoidArea: window.AvoidArea = {
    topRect: { left: 0, top: 0, width: 0, height: 0 },
    bottomRect: { left: 0, top: 0, width: 0, height: 0 },
    leftRect: { left: 0, top: 0, width: 0, height: 0 },
    rightRect: { left: 0, top: 0, width: 0, height: 0 },
    visible: false
  };
  @State navAvoidArea: window.AvoidArea = {
    topRect: { left: 0, top: 0, width: 0, height: 0 },
    bottomRect: { left: 0, top: 0, width: 0, height: 0 },
    leftRect: { left: 0, top: 0, width: 0, height: 0 },
    rightRect: { left: 0, top: 0, width: 0, height: 0 },
    visible: false
  };

  aboutToAppear() {
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    
    window.getLastWindow(context, (err, win) => {
      if (err.code !== 0) {
        console.error('获取窗口失败:', err);
        return;
      }
      
      this.avoidArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      this.systemAvoidArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      this.navAvoidArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      
      win.on('avoidAreaChange', (data) => {
        if (data.type === window.AvoidAreaType.TYPE_SYSTEM) {
          this.avoidArea = data.area;
          this.systemAvoidArea = data.area;
        } else if (data.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          this.navAvoidArea = data.area;
        }
      });
    });
  }

  build() {
    Column() {
      Text('系统避让区域')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
      Text(`顶部高度: ${this.systemAvoidArea.topRect.height}`)
      Text(`底部高度: ${this.systemAvoidArea.bottomRect.height}`)
      Text(`左侧宽度: ${this.systemAvoidArea.leftRect.width}`)
      Text(`右侧宽度: ${this.systemAvoidArea.rightRect.width}`)
      Text(`可见: ${this.systemAvoidArea.visible}`)
      
      Divider()
      
      Text('导航栏避让区域')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
      Text(`顶部高度: ${this.navAvoidArea.topRect.height}`)
      Text(`底部高度: ${this.navAvoidArea.bottomRect.height}`)
      Text(`左侧宽度: ${this.navAvoidArea.leftRect.width}`)
      Text(`右侧宽度: ${this.navAvoidArea.rightRect.width}`)
      Text(`可见: ${this.navAvoidArea.visible}`)
    }
    .padding(20)
  }
}

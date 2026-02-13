import { display } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct FoldStatusReplacement {
  @State foldStatus: string = '未知';
  @State availableAreaWidth: number = 0;

  aboutToAppear() {
    try {
      const defaultDisplay = display.getDefaultDisplaySync();
      this.availableAreaWidth = defaultDisplay.width;
      
      defaultDisplay.on('availableAreaChange', (data) => {
        this.availableAreaWidth = data.width;
        this.foldStatus = data.width < 600 ? '折叠态' : '展开态';
        hilog.info(0xFF00, 'FoldStatusReplacement', 'Available area changed: width=%{public}d', data.width);
      });
    } catch (err) {
      hilog.error(0xFF00, 'FoldStatusReplacement', 'Failed to get display: %{public}s', JSON.stringify(err));
    }
  }

  aboutToDisappear() {
    try {
      const defaultDisplay = display.getDefaultDisplaySync();
      defaultDisplay.off('availableAreaChange');
    } catch (err) {
      hilog.error(0xFF00, 'FoldStatusReplacement', 'Failed to remove listener: %{public}s', JSON.stringify(err));
    }
  }

  build() {
    Column() {
      Text('折叠状态监听示例')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 16 })
      
      Text(`状态: ${this.foldStatus}`)
        .fontSize(16)
        .fontColor('#333333')
        .margin({ bottom: 8 })
      
      Text(`可用区域宽度: ${this.availableAreaWidth}`)
        .fontSize(16)
        .fontColor('#666666')
    }
    .width('100%')
    .padding(16)
  }
}
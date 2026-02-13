import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct ScrollEventReplacement {
  @State scrollOffset: number = 0;
  private scroller: Scroller = new Scroller();

  build() {
    Column() {
      Text('onWillScroll 替代示例')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 16 })
      
      Text(`滚动偏移: ${this.scrollOffset}`)
        .fontSize(16)
        .fontColor('#333333')
        .margin({ bottom: 16 })
      
      Scroll(this.scroller) {
        Column() {
          ForEach(Array.from({ length: 50 }), (_: Object, index: number) => {
            Text(`Item ${index + 1}`)
              .fontSize(16)
              .padding(12)
              .margin({ bottom: 8 })
              .backgroundColor('#F5F5F5')
              .borderRadius(4)
          }, (_: Object, index: number) => `${index}`)
        }
        .width('100%')
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Auto)
      .onWillScroll((_xOffset: number, yOffset: number) => {
        this.scrollOffset = yOffset;
        hilog.info(0xFF00, 'ScrollEvent', 'Scroll offset: %{public}d', yOffset);
      })
    }
    .width('100%')
    .height('100%')
    .padding(16)
  }
}
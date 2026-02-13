import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct ScrollDidScrollReplacement {
  @State scrollOffset: number = 0;
  @State scrollState: string = 'Idle';
  private scroller: Scroller = new Scroller();

  build() {
    Column() {
      Text('onDidScroll 替代示例')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 16 })
      
      Column({ space: 8 }) {
        Text(`滚动偏移: ${this.scrollOffset}`)
          .fontSize(16)
          .fontColor('#333333')
        
        Text(`滚动状态: ${this.scrollState}`)
          .fontSize(16)
          .fontColor('#333333')
      }
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
      .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
        this.scrollOffset = scrollOffset;
        this.scrollState = this.getScrollStateName(scrollState);
        hilog.info(0xFF00, 'ScrollEvent', 'Scroll offset: %{public}d, state: %{public}d', scrollOffset, scrollState);
      })
      .onReachStart(() => {
        hilog.info(0xFF00, 'ScrollEvent', 'Scroll reached start');
      })
      .onReachEnd(() => {
        hilog.info(0xFF00, 'ScrollEvent', 'Scroll reached end');
      })
      .onScrollEdge((side: Edge) => {
        hilog.info(0xFF00, 'ScrollEvent', 'Scroll edge: %{public}d', side);
      })
    }
    .width('100%')
    .height('100%')
    .padding(16)
  }

  private getScrollStateName(state: ScrollState): string {
    switch (state) {
      case ScrollState.Idle:
        return 'Idle';
      case ScrollState.Scroll:
        return 'Scroll';
      case ScrollState.Fling:
        return 'Fling';
      default:
        return 'Unknown';
    }
  }
}

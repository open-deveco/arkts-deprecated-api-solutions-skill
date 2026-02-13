import display from '@ohos.display';

@Entry
@Component
struct DisplayReplacement {
  @State orientation: string = 'Unknown';

  aboutToAppear() {
    try {
      const defaultDisplay = display.getDefaultDisplaySync();
      this.orientation = defaultDisplay.orientation === display.Orientation.PORTRAIT ? 'Portrait' : 'Landscape';
    } catch (err) {
      console.error('Failed to get display info:', err);
    }
  }

  build() {
    Column() {
      Text(`Orientation: ${this.orientation}`)
    }
  }
}

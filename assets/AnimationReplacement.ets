@Entry
@Component
struct AnimationReplacement {
  @State widthSize: number = 200;

  build() {
    Column() {
      Button('Animate')
        .width(this.widthSize)
        .onClick(() => {
          // Modern usage: getUIContext().animateTo
          this.getUIContext().animateTo({ duration: 1000 }, () => {
            this.widthSize = 300;
          });
        })
    }
  }
}

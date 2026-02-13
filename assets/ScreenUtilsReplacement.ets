@Entry
@Component
struct ScreenUtilsReplacement {
  build() {
    Column() {
      Button('Get VP')
        .onClick(() => {
          // Modern usage: getUIContext().px2vp
          let vp = this.getUIContext().px2vp(100);
          console.info(`100px = ${vp}vp`);
        })
    }
  }
}

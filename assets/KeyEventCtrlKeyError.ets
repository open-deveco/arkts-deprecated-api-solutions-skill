@Entry
@Component
struct KeyEventCtrlKeyError {
  @State message: string = '按 Ctrl+S 保存';
  @State showToast: boolean = false;

  build() {
    Column() {
      Text('键盘快捷键示例')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 16 })
      
      Text(this.message)
        .fontSize(16)
        .fontColor('#333333')
        .margin({ bottom: 16 })
      
      Text('按 Ctrl+S 保存内容')
        .fontSize(14)
        .fontColor('#666666')
      
      if (this.showToast) {
        Text('保存成功')
          .fontSize(14)
          .fontColor('#666666')
          .margin({ top: 8 })
      }
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .keyboardShortcut('s', [ModifierKey.CTRL], () => {
      this.message = '已保存！';
      this.showToast = true;
      setTimeout(() => {
        this.showToast = false;
      }, 2000);
    })
  }
}
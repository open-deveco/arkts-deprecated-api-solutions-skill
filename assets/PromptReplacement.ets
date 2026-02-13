@Entry
@Component
struct PromptReplacement {
  build() {
    Button('Toast')
      .onClick(() => {
        // Modern usage: getUIContext().getPromptAction()
        this.getUIContext().getPromptAction().showToast({
          message: 'Operation Successful',
          duration: 2000
        });
      })
  }
}

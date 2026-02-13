class PropAClass {
  PropA: number = 47;
}
let para: Record<string, number> = { 'PropA': 47 };
let storage = new LocalStorage(para);

@Entry(storage)
@Component
struct StateManagementReplacement {
  @LocalStorageLink('PropA') storageLink: number = 1;

  build() {
    Column() {
      Text(`Value: ${this.storageLink}`)
      Button('Update')
        .onClick(() => {
          this.storageLink += 1;
        })
    }
  }
}

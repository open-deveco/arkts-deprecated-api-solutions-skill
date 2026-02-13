import { router } from '@kit.ArkUI';

@Entry
@Component
struct RouterReplacement {
  build() {
    Button('Navigate')
      .onClick(() => {
        // Modern usage: getUIContext().getRouter()
        const routerInstance = this.getUIContext().getRouter();
        routerInstance.pushUrl({ url: 'pages/NextPage' });
      })
  }
}

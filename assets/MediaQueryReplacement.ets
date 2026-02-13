import { mediaquery } from '@kit.ArkUI';

@Entry
@Component
struct MediaQueryReplacement {
  private mediaListener: mediaquery.MediaQueryListener | null = null;
  
  @State isWideScreen: boolean = false;

  aboutToAppear() {
    this.mediaListener = this.getUIContext().getMediaQuery().matchMediaSync('(min-width: 600vp)');
    if (this.mediaListener) {
      this.isWideScreen = this.mediaListener.matches;
      this.mediaListener.on('change', (result: mediaquery.MediaQueryResult) => {
        this.isWideScreen = result.matches;
      });
    }
  }

  aboutToDisappear() {
    if (this.mediaListener) {
      this.mediaListener.off('change');
    }
  }

  build() {
    if (this.isWideScreen) {
      Row() {
        Text('Wide Screen Layout')
      }
    } else {
      Column() {
        Text('Narrow Screen Layout')
      }
    }
  }
}

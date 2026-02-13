import { fileIo as fs } from '@kit.CoreFileKit';
import { common } from '@kit.AbilityKit';

@Entry
@Component
struct FileMigration {
  @State fileContent: string = '';

  writeFile() {
    // getContext is deprecated, use this.getUIContext().getHostContext() as common.UIAbilityContext
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let filesDir = context.filesDir;

    let path = filesDir + '/test.txt';
    
    // Modern usage: fs.open, fs.write
    let file = fs.openSync(path, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.writeSync(file.fd, 'Hello File System V2');
    fs.closeSync(file);
  }

  readFile() {
    // getContext is deprecated, use this.getUIContext().getHostContext() as common.UIAbilityContext
    const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    let filesDir = context.filesDir;
    let path = filesDir + '/test.txt';

    if (!fs.accessSync(path)) {
      this.fileContent = 'File not found';
      return;
    }

    // Modern usage: fs.read
    let file = fs.openSync(path, fs.OpenMode.READ_ONLY);
    let buf = new ArrayBuffer(1024);
    let readLen = fs.readSync(file.fd, buf);
    this.fileContent = String.fromCharCode(...new Uint8Array(buf.slice(0, readLen)));
    fs.closeSync(file);
  }

  build() {
    Column() {
      Button('Write File').onClick(() => this.writeFile())
      Button('Read File').onClick(() => this.readFile())
      Text(this.fileContent).margin(10)
    }
  }
}

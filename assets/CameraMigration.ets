import { camera } from '@kit.CameraKit';
import { common } from '@kit.AbilityKit';
import image from '@ohos.multimedia.image';
import { fileIo } from '@kit.CoreFileKit';

@Entry
@Component
struct CameraMigration {
  private context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private cameraManager: camera.CameraManager | null = null;
  private cameraInput: camera.CameraInput | null = null;
  private previewOutput: camera.PreviewOutput | null = null;
  private captureSession: camera.Session | null = null;
  private photoOutput: camera.PhotoOutput | null = null;
  private surfaceId: string = '';
  
  @State isCameraRunning: boolean = false;
  @State cameraStatus: string = '未初始化';

  async aboutToAppear() {
    this.cameraManager = camera.getCameraManager(this.context);
    await this.initCamera();
  }

  aboutToDisappear() {
    this.releaseCamera();
  }

  async initCamera() {
    try {
      const cameras = this.cameraManager!.getSupportedCameras();
      if (cameras.length === 0) {
        this.cameraStatus = '没有可用的相机';
        return;
      }

      const cameraDevice = cameras[0];
      await this.setupCamera(cameraDevice);
      this.cameraStatus = '相机已初始化';
    } catch (error) {
      console.error('初始化相机失败:', error);
      this.cameraStatus = '初始化失败';
    }
  }

  async setupCamera(cameraDevice: camera.CameraDevice) {
    try {
      const profiles = this.cameraManager!.getSupportedOutputCapability(cameraDevice, camera.SceneMode.NORMAL_VIDEO);
      const previewProfile = profiles.previewProfiles[0];
      
      this.cameraInput = this.cameraManager!.createCameraInput(cameraDevice);
      await this.cameraInput.open();
      
      this.previewOutput = this.cameraManager!.createPreviewOutput(previewProfile, this.surfaceId);
      
      this.captureSession = this.cameraManager!.createSession(camera.SceneMode.NORMAL_VIDEO);
      this.captureSession.beginConfig();
      this.captureSession.addInput(this.cameraInput);
      this.captureSession.addOutput(this.previewOutput);
      await this.captureSession.commitConfig();
      
      await this.captureSession.start();
      this.isCameraRunning = true;
    } catch (error) {
      console.error('设置相机失败:', error);
      throw new Error('设置相机失败');
    }
  }

  async takePicture() {
    if (!this.cameraManager || !this.captureSession) {
      return;
    }

    try {
      const cameras = this.cameraManager.getSupportedCameras();
      if (cameras.length === 0) {
        return;
      }

      const profiles = this.cameraManager.getSupportedOutputCapability(cameras[0], camera.SceneMode.NORMAL_PHOTO);
      const photoProfile = profiles.photoProfiles[0];
      
      this.photoOutput = this.cameraManager.createPhotoOutput(photoProfile);
      
      this.captureSession.beginConfig();
      this.captureSession.addOutput(this.photoOutput);
      await this.captureSession.commitConfig();
      
      this.photoOutput.on('photoAvailable', (err, photo) => {
        if (!err && photo) {
          this.savePhoto(photo);
        }
      });
      
      await this.photoOutput.capture();
      
      this.captureSession.beginConfig();
      this.captureSession.removeOutput(this.photoOutput);
      await this.captureSession.commitConfig();
      
      if (this.photoOutput) {
        this.photoOutput.release();
        this.photoOutput = null;
      }
    } catch (error) {
      console.error('拍照失败:', error);
    }
  }

  savePhoto(photo: camera.Photo) {
    try {
      const imagePacker = image.createImagePacker();
      const packOption: image.PackingOption = {
        format: 'image/jpeg',
        quality: 100
      };
      
      const path = this.context.cacheDir + '/photo.jpg';
      const file = fileIo.openSync(path, fileIo.OpenMode.CREATE | fileIo.OpenMode.READ_WRITE);
      
      const mainImage = photo.main;
      mainImage.getComponent(image.ComponentType.JPEG, (err, component) => {
        if (err) {
          console.error('获取JPEG组件失败:', err);
          fileIo.closeSync(file.fd);
          return;
        }
        
        const buffer = component.byteBuffer;
        const imageSource = image.createImageSource(buffer);
        imageSource.createPixelMap((err, pixelMap) => {
          if (err) {
            console.error('创建PixelMap失败:', err);
            fileIo.closeSync(file.fd);
            return;
          }
          
          imagePacker.packToFile(pixelMap, file.fd, packOption, (err) => {
            if (err) {
              console.error('保存照片失败:', err);
            } else {
              console.log('照片已保存:', path);
            }
            fileIo.closeSync(file.fd);
          });
        });
      });
    } catch (error) {
      console.error('保存照片失败:', error);
    }
  }

  async releaseCamera() {
    if (this.captureSession) {
      await this.captureSession.stop();
      this.captureSession.release();
      this.captureSession = null;
    }
    if (this.previewOutput) {
      this.previewOutput.release();
      this.previewOutput = null;
    }
    if (this.photoOutput) {
      this.photoOutput.release();
      this.photoOutput = null;
    }
    if (this.cameraInput) {
      this.cameraInput.close();
      this.cameraInput = null;
    }
    this.isCameraRunning = false;
    this.cameraStatus = '相机已释放';
  }

  build() {
    Column() {
      Text(`相机状态: ${this.cameraStatus}`)
        .fontSize(20)
        .margin(20)

      XComponent({
        id: 'cameraPreview',
        type: XComponentType.SURFACE
      })
        .onLoad((event) => {
          this.surfaceId = (event as Record<string, Object>).surfaceId as string;
          console.log('Surface ID:', this.surfaceId);
        })
        .width('100%')
        .height(400)
        .backgroundColor('#000000')
        .margin(20)

      Row() {
        Button('拍照')
          .onClick(() => {
            this.takePicture();
          })
          .enabled(this.isCameraRunning)
          .margin({ right: 10 })

        Button('释放相机')
          .onClick(() => {
            this.releaseCamera();
          })
      }
      .margin(20)
    }
    .width('100%')
    .height('100%')
  }
}
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import {Logger} from "@nestjs/common";
import {ConfigService} from "@nestjs/config";

declare const module: any;

async function bootstrap() {
  const logger = new Logger('AppBootstrap');
  const app = await NestFactory.create(AppModule);

  const configService = app.get(ConfigService);

  app.enableCors({
    allowedHeaders: '*',
    origin: '*',
    credentials: true,
  });

  const port = configService.get('port');
  await app.listen(port);
  logger.log(`App is listening on ${port}`);

  if (module.hot) {
    module.hot.accept();
    module.hot.dispose(() => app.close());
  }
}
bootstrap();

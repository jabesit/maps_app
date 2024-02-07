/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:maps_app/blocs/blocs.dart';
import 'package:maps_app/screens/screens.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/media_information_session.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/media_information_session.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:path_provider/path_provider.dart';

class LoadingScreenVVVV extends StatefulWidget {
  const LoadingScreenVVVV({super.key});

  @override
  State<LoadingScreenVVVV> createState() => _LoadingScreenVVVVState();
}

class _LoadingScreenVVVVState extends State<LoadingScreenVVVV> {
  call() async {
    var a = VideoProcessor();
    await a.processVideo(
        "https://file-examples.com/storage/fed04812b965b2454998b56/2018/04/file_example_MOV_1920_2_2MB.mov");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
    );
  }
}

class VideoProcessor {
  final FFmpegKit _flutterFFmpeg = FFmpegKit();

  Future<void> processVideo(String inputVideoPath) async {
    // Obtén la duración del video
    double duration = 0;
    await FFprobeKit.getMediaInformation(inputVideoPath).then((session) async {
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        final information = await session.getMediaInformation();
        duration = double.parse(information!.getDuration()!);
      }
    });

    // Inicializa variables
    double currentTime = 0;
    List<String> filterSegments = [];
    List<String> concatSegments = [];

    // Procesa segmentos de 10 segundos
    while (currentTime < duration) {
      double nextSegmentDuration = 10;
      if (currentTime + nextSegmentDuration > duration) {
        nextSegmentDuration = duration - currentTime;
      }

      // Comando para aumentar la velocidad 3x
      int segmentIndex = filterSegments.length;
      filterSegments.add(
          "[0:v]trim=start=$currentTime:end=${currentTime + nextSegmentDuration},setpts=PTS/${1}[v$segmentIndex];");
      filterSegments.add(
          "[0:a]atrim=start=$currentTime:end=${currentTime + nextSegmentDuration},asetpts=PTS-STARTPTS,atempo=2,atempo=1.5[a$segmentIndex];");
      concatSegments.add("[v$segmentIndex][a$segmentIndex]");
      currentTime += nextSegmentDuration;
    }

    // Construye el filtro complex
    String filterComplex = filterSegments.join('') +
        concatSegments.join('') +
        "concat=n=${concatSegments.length}:v=1:a=1[outv][outa]";

    // Define el path de salida
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String outputPath = '${appDocDir.path}/output.mp4';

    // Ejecuta el comando FFmpeg
    final command =
        "-i $inputVideoPath -filter_complex \"$filterComplex\" -map \"[outv]\" -map \"[outa]\" $outputPath";
    print("command");
    print(command);
    print("command");
    await FFmpegKit.execute(command).then((session) async {
      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        print("Video procesado exitosamente. Guardado en: $outputPath");
      } else {
        print("Error al procesar el video. Código de retorno: $returnCode");
      }
    });
  }
}

*/
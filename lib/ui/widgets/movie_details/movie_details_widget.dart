import 'package:dart_lesson/library/provider.dart';
import 'package:dart_lesson/ui/widgets/app/my_app_model.dart';
import 'package:dart_lesson/ui/widgets/movie_details/movie_details_main_info_widget.dart';
import 'package:flutter/material.dart';

import '../../theme/app_bar_and_serach_color.dart';
import 'movie_dateils_main_screen_cast_widget.dart';
import 'movie_details_model.dart';

class MovieDetailsWidget extends StatefulWidget {
  MovieDetailsWidget({
    Key? key,
  }) : super(key: key);

  @override
  _MovieDetailsWidgetState createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  @override
  void initState() {
    super.initState();
    final model = NotifierProvider.read<MovieDetailsModel>(context);
    final appModel = Provider.read<MyAppModel>(context);
    model?.onSessionExpired = () => appModel?.resetSession(context);
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    NotifierProvider.read<MovieDetailsModel>(context)?.setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const _TitleWidget(),
      ),
      body: ColoredBox(
        color: const Color.fromRGBO(24, 23, 27, 1.0),
        child:
            _BodyWidget(),
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    return Text(
      model?.movieDetails?.title ?? 'Загрузка..',
      style: AppBartxtColor.styleWhite,
    );
  }
}

class _BodyWidget extends StatelessWidget {
  _BodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final movieDetails = model?.movieDetails;
    if (movieDetails == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      children: [
        const MovieDetailsMainInfoWidget(),
        const SizedBox(height: 30),
        const MovieDetailsMainScreenCastWidget(),
      ],
    );
  }
}

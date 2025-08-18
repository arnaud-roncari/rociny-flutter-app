import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/core/utils/error_handling/alert.dart';
import 'package:rociny/features/influencer/collaborations/bloc/collaboration_bloc.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';
import 'package:rociny/shared/widgets/button.dart';
import 'package:rociny/shared/widgets/svg_button.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController controller = TextEditingController();
  int stars = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(kPadding20),
          child: BlocConsumer<CollaborationBloc, CollaborationState>(
            listener: (context, state) {
              if (state is CreateReviewFailed) {
                Alert.showError(context, state.exception.message);
              }

              if (state is CreateReviewSuccess) {
                final bloc = context.read<CollaborationBloc>();
                bloc.add(
                  Initialize(userId: bloc.company.userId, collaborationId: bloc.collaboration.id),
                );
                context.pop();
              }
            },
            builder: (context, state) {
              if (state is CreateReviewLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: kPrimary500,
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgButton(
                        path: "assets/svg/left_arrow.svg",
                        color: kBlack,
                        onPressed: () {
                          context.pop();
                        },
                      ),
                      const Spacer(),
                      Text(
                        "Évaluation",
                        style: kTitle1Bold,
                      ),
                      const Spacer(),
                      const SizedBox(width: kPadding20),
                    ],
                  ),
                  const SizedBox(height: kPadding30),
                  Text("Étoile", style: kTitle1Bold),
                  const SizedBox(height: kPadding10),
                  Text(
                    "Quelle note attribuez-vous à l'influenceur ?",
                    style: kBody.copyWith(color: kGrey300),
                  ),
                  const SizedBox(height: kPadding20),
                  Row(
                    children: [
                      SvgButton(
                        path: getPath(stars >= 1),
                        color: kBlack,
                        onPressed: () {
                          setState(() {
                            stars = 1;
                          });
                        },
                      ),
                      SvgButton(
                        path: getPath(stars >= 2),
                        color: kBlack,
                        onPressed: () {
                          setState(() {
                            stars = 2;
                          });
                        },
                      ),
                      SvgButton(
                        path: getPath(stars >= 3),
                        color: kBlack,
                        onPressed: () {
                          setState(() {
                            stars = 3;
                          });
                        },
                      ),
                      SvgButton(
                        path: getPath(stars >= 4),
                        color: kBlack,
                        onPressed: () {
                          setState(() {
                            stars = 4;
                          });
                        },
                      ),
                      SvgButton(
                        path: getPath(stars >= 5),
                        color: kBlack,
                        onPressed: () {
                          setState(() {
                            stars = 5;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: kPadding30),
                  Text("Commentaire", style: kTitle1Bold),
                  const SizedBox(height: kPadding10),
                  Text(
                    "Rédigez un commentaire sur votre collaboration avec l'influenceur. Ce commentaire sera visible par l'influenceur et les autres entreprises.",
                    style: kBody.copyWith(color: kGrey300),
                  ),
                  const SizedBox(height: kPadding20),
                  TextField(
                    decoration: kTextFieldDecoration.copyWith(hintText: "Description"),
                    style: kBody,
                    maxLength: 1000,
                    controller: controller,
                  ),
                  const Spacer(),
                  Button(
                    title: "Évaluer",
                    onPressed: () {
                      context.read<CollaborationBloc>().add(
                            CreateReview(
                              stars: stars,
                              description: controller.text,
                            ),
                          );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String getPath(bool isNotEmpty) {
    if (isNotEmpty) {
      return "assets/svg/star.svg";
    }
    return "assets/svg/star_empty.svg";
  }
}

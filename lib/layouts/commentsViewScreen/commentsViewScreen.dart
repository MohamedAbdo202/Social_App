import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/layoutCubit/layoutCubit.dart';
import 'package:social_app/layouts/layoutCubit/layoutStates.dart';
import 'package:social_app/models/commentModel.dart';
import '../../lib/shared/components/components.dart';
import '../../lib/shared/styles/colors.dart';

class CommentsScreen extends StatelessWidget {
  bool comeFromHomeScreenNotPostDetailsScreen;
  final commentController = TextEditingController();
  int? postIndex ;
  String postMakerID;
  String postID;  // to enable to get the comments for this post
  CommentsScreen({super.key,required this.postID,required this.postMakerID,this.postIndex,required this.comeFromHomeScreenNotPostDetailsScreen});
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        LayoutCubit.getCubit(context).getComments(postMakerID: postMakerID, postID: postID);
        return BlocConsumer<LayoutCubit,LayoutStates>(
            listener: (context,state)
            {
              if( comeFromHomeScreenNotPostDetailsScreen != true && state is AddCommentSuccessState )
                {
                  LayoutCubit.getCubit(context).openCommentsThrowPostDetailsScreen = true;
                  LayoutCubit.getCubit(context).usersPostsData.clear();
                  LayoutCubit.getCubit(context).postsID.clear();
                  LayoutCubit.getCubit(context).commentsNumber.clear();
                  LayoutCubit.getCubit(context).likesPostsData.clear();
                  LayoutCubit.getCubit(context).getUsersPosts();
                }
            },
            builder: (context,state){
              final cubit = LayoutCubit.getCubit(context);
              return Scaffold(
                appBar: AppBar(
                  titleSpacing: 0,
                  title: const Text("Comments"),
                  leading: defaultTextButton(title: const Icon(Icons.arrow_back_ios), onTap: (){Navigator.pop(context);}),
                ),
                body: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.5,horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                        [
                          state is GetCommentsLoadingState ?
                              const Center(child: CupertinoActivityIndicator(),) :
                              Expanded(
                                    child: cubit.comments.isNotEmpty ?
                                      ListView.separated(
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context,i){ return buildCommentItem(model: cubit.comments[i]);},
                                        separatorBuilder: (context,i){return const SizedBox(height: 15.0);},
                                        itemCount: cubit.comments.length,) :
                                      const Center(child: Text("No Comments yet",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 17),))
                              ),
                          Row(
                            children:
                            [
                              CircleAvatar(
                                radius: 23,
                                backgroundImage: NetworkImage(cubit.userData!.image!),
                              ),
                              const SizedBox(width: 10,),
                              Expanded(
                                child: StatefulBuilder(
                                  builder: (context,setState){
                                    return TextFormField(
                                      controller: commentController,
                                      onFieldSubmitted: (val)
                                      {
                                        cubit.addComment(comment: val,postID:postID,postMakerID: postMakerID);
                                        setState((){
                                          commentController.text = '';
                                          cubit.commentsNumber[postIndex!] = cubit.commentsNumber[postIndex!] + 1 ;
                                        });
                                        if( comeFromHomeScreenNotPostDetailsScreen == true )
                                          {
                                            cubit.openCommentsThrowPostDetailsScreen = false;  // عشان انا هلعب ع قيمه المتغير ده ف انه يعمل getUsersPosts ولا لاء ....
                                          }
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(22),borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 5,horizontal: 12.0),
                                        hintText: "add a new comment...",
                                        hintStyle: Theme.of(context).textTheme.caption!.copyWith(fontSize: 14),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
              );
            },
        );
      }
    );
  }

  Widget buildCommentItem({required CommentDataModel model}){
    return Row(
      children:
      [
        CircleAvatar(
          radius: 27,
          backgroundImage: NetworkImage(model.commentMakerImage!),
        ),
        const SizedBox(width: 10,),
        Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),border: Border.all(color: Colors.grey.withOpacity(0.5))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  Text(model.commentMakerName!,style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 16),),
                  const SizedBox(height: 3,),
                  Text(model.comment!,style: TextStyle(color: blackColor.withOpacity(0.6),fontSize: 14.5),),
                ],
              )
            )
        ),
      ],
    );
  }
}

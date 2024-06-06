enum PostStatus { initial, loading, success, error }

class PostState {
  final PostStatus status;
  final String errorMessage;

  PostState({required this.status, this.errorMessage = ''});

  factory PostState.initial() => PostState(status: PostStatus.initial);

  factory PostState.loading() => PostState(status: PostStatus.loading);

  factory PostState.success() => PostState(status: PostStatus.success);

  factory PostState.error(String errorMessage) =>
      PostState(status: PostStatus.error, errorMessage: errorMessage);
}

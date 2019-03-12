package Jobeet::Controller::Category;
use Ark 'Controller';
use Jobeet::Models;

sub show :Path :Args(1) {
    my ($self, $c, $category_name) = @_;

    # カテゴリを検索する
    my $category = models('Schema::Category')->find({ slug => $category_name })
        or $c->detach('/default');

    # 見つかったカテゴリをテンプレートに渡す
    $c->stash->{category} = $category;

    # jobs として ResultSet オブジェクトをテンプレートに渡す
    $c->stash->{jobs} = $category->get_active_jobs({
        rows => models('conf')->{max_jobs_on_category},
        page => $c->req->parameters->{page} || 1,
    });
}

1;

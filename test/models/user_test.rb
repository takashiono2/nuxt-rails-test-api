require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = active_user
  end

  test "name_validation" do
    # 入力必須
    user = User.new(email: "test@example.com", password: "password")
    user.save
    required_msg = ["名前を入力してください"]
    assert_equal(required_msg, user.errors.full_messages)
    # 30文字以上
    max = 30
    name = "a" * (max + 1)
    user.name = name
    user.save
    maxlength_msg = ["名前は30文字以内で入力してください"]
    assert_equal(maxlength_msg, user.errors.full_messages)
    # 30文字以内は正しく保存されているか
    name = "あ" * max
    user.name = name
    assert_difference("User.count", 1) do
      user.save
    end

  end

  test "email_validation" do
    # 入力必須
    user = User.new(name: "test", password: "password")
    user.save
    required_msg = ["メールアドレスを入力してください"]
    assert_equal(required_msg, user.errors.full_messages)

    # 255文字制限
    max = 255
    domain = "@example.com"
    email = "a" * ((max + 1) - domain.length) + domain
    assert max < email.length
    user.email = email
    user.save
    maxlength_msg = ["メールアドレスは255文字以内で入力してください"]
    assert_equal(maxlength_msg, user.errors.full_messages)

    # 書式チェック format = /\A\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*\z/
    ok_emails = %w(
      A@EX.COM
      a-_@e-x.c-o_m.j_p
      a.a@ex.com
      a@e.co.js
      1.1@ex.com
      a.a+a@ex.com
    )
    ok_emails.each do |email|
      user.email = email
      assert user.save
    end

    ng_emails = %w(
      aaa
      a.ex.com
      メール@ex.com
      a~a@ex.com
      a@|.com
      a@ex.
      .a@ex.com
      a＠ex.com
      Ａ@ex.com
      a@?,com
      １@ex.com
      "a"@ex.com
      a@ex@co.jp
    )
    ng_emails.each do |email|
        user.email = email
        user.save
        format_msg = ["メールアドレスは不正な値です"]
        assert_equal(format_msg, user.errors.full_messages)
    end
  end

  test "email_downcase" do
    # email小文字化テスト
    email = "USER@EXAMPLE.COM"
    user = User.new(email: email)
    user.save
    assert user.email == email.downcase
  end
end

class User::Reset < User::Base

  def call
    find_user
    check_consistency
    update_password
    validate_model
    reset_validation_token
    user.save!
  end

  private

  def find_user
    context.user = User.find_by(validation_token: context.key)
  end

  def check_consistency
    context.fail!(error: "Você não tem permissão para essa ação") unless user.member_without_access?
    context.fail!(error: "Esse token já não é mais válido") if Time.now > user.validation_token_sent_at + 8.hours
  end

  def update_password
    user.password = context.password
    user.password_confirmation = context.password_confirmation
    user.validation_token = nil
    user.validation_token_sent_at = nil
  end

  def validate_model
    context.fail!(error: user.errors.full_messages.join(". ")) unless user.valid?
  end
end
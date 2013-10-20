class ChallengeDecorator < Draper::Decorator
  delegate_all

  def type_icon
    case model
    when TopChallenge
      'glyphicon-bookmark'
    when SingleChallenge
      'glyphicon-flag'
    when PersonalChallenge
      'glyphicon-star'
    end
  end
end

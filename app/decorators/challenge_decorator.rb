class ChallengeDecorator < Draper::Decorator
  delegate_all

  def type_icon
    type_icon_for_class(model.class)
  end

  def type_icon_for_class(klass)
    if klass == TopChallenge
      'glyphicon-bookmark'
    elsif klass == SingleChallenge
      'glyphicon-flag'
    else # PersonalChallenge
      'glyphicon-star'
    end
  end

  def difficulty
    case model.difficulty
    when 1
      'easy'
    when 2
      'medium'
    when 3
      'hard'
    end
  end
end

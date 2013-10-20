namespace :seed do
  desc 'Delete user, groups, challenges'
  task :delete => :environment do
    Group.destroy_all
    User.destroy_all
    Challenge.destroy_all
  end

  desc "Create seeds"
  task :create => :environment do
    Rake::Task["seed:groups"].invoke
    Rake::Task["seed:users"].invoke
    Rake::Task["seed:challenges"].invoke
  end

  desc 'Create users'
  task :users => :environment do
    users = [
      # user
      {
        email: 'hugoamorimlyra@gmail.com',
        title: 'Hugo Amo',
      },


      # user
      {
        email: 'me@lesaker.org',
        title: 'It\'s a Me',
      },


      # user
      {
        email: 'alexis.rinaldoni@infopark.de',
        title: 'Alexis',
      },


      # user
      {
        email: 'bob@bob.com',
        title: 'My Name is Bob',
      },


      # user
      {
        email: 'asdasd@foo.com',
        title: 'KeyboardLover',
      },


      # user
      {
        email: 'frankalbenesius@gmail.com',
        title: 'Frank',
      },


      # user
      {
        email: 'babichevv@gmail.com',
        title: 'Babichevv',
      },


      # user
      {
        email: 'falk.koeppe@gmail.com',
        title: 'Falk',
      },

      # user
      {
        email: 'sandra.schmidt@infopark.de',
        title: 'Sandra',
      },

      # user
      {
        email: 'falk.koeppe@infopark.de',
        title: 'Falk',
      },

      # user
      {
        email: 'rowaweb@gmail.com',
        title: 'Lars Lagerfeuer',
      },

      # user
      {
        email: 'sandra.schmidt.bln@googlemail.com',
        title: 'Sandra',
      },

      # user
      {
        email: 'john@yopmail.com',
        title: 'John',
      },

      # user
      {
        email: 'hugo@mail.org',
        title: 'Hugo',
      },

      # user
      {
        email: 'naseleznev@list.ru',
        title: 'Naseleznev',
      },

      # user
      {
        email: 'nitsch99f@hotmail.com',
        title: 'Nitsch',
      },

      # user
      {
        email: 'naseleznev@list.ru',
        title: 'Naseleznev',
      },

      # user
      {
        email: 'sarah.c.k@web.de',
        title: 'Sarah',
      },
    ]

    users.each do |attr|
      user = User.where(email: attr[:email]).first

      unless user
        user = User.create!(attr)
      end

      Group.each do |group|
        dice = (rand() * 6.0).to_i;

        if dice > 3
          group.add_user(user)
        end
      end
    end
  end

  desc 'Create groups'
  task :groups => :environment do
    all_groups = [
      # group
      {
        name: 'Family',
        description: 'Don\'t ask what your family can do for you, but what you can do for your family.',
        image_url: 'http://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Dirty_dishes.jpg/320px-Dirty_dishes.jpg?uselang=de',
      },
      # group
      {
        name: 'Fleet Street 23a',
        description: 'A group for alle residents of Fleet Street 23a',
        image_url: 'http://upload.wikimedia.org/wikipedia/commons/thumb/3/31/Ivy_Covered_House.jpg/300px-Ivy_Covered_House.jpg?uselang=de',
      },
      # group
      {
        name: 'Ride more Bikes',
        description: 'Bikes run on fat and save money, while cars run on money and make you fat!',
        image_url: 'http://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Bike_buddies.jpg/320px-Bike_buddies.jpg?uselang=de',
      },
      # group
      {
        name: 'Say no to Procrastination',
        description: 'Need some support to get things done? Join our group and get challenged to be more productive',
        image_url: 'http://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Zoo_Dortmund_Faultier.jpg/320px-Zoo_Dortmund_Faultier.jpg?uselang=de',
      },
      # group
      {
        name: 'The Avengers',
        description: 'Who\'s best at saving the world?',
        image_url: 'http://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Avengers_symbol.png/209px-Avengers_symbol.png?uselang=de',
      },
      # group
      {
        name: 'The Dark Side',
        description: 'Join the dark side, we have points...',
        image_url: 'http://upload.wikimedia.org/wikipedia/commons/e/e5/Three_stars_and_crescent.png?uselang=de',
      },
      # group
      {
        name: '2014 Winter Olypmics',
        description: 'Fans of the Winter Olympics, next in February 2014 in Sotchi, Russia.',
        image_url: 'http://upload.wikimedia.org/wikipedia/commons/d/d2/Olympics.gif?uselang=de',
      },
      # group
      {
        name: 'Berlin',
        description: 'A group for people living in the best city in the world',
        image_url: 'http://upload.wikimedia.org/wikipedia/commons/5/5d/Berlinermauer.jpg',
      },
    ]

    all_groups.each do |attr|
      Group.create!(attr) unless Group.where(name: attr[:name]).present?
    end
  end

  desc 'Create challenges'
  task :challenges => :environment do
    creator = User.where(email: 'rowaweb@gmail.com').first || User.create!(email: 'rowaweb@gmail.com')

    def create_challenges(group, challenges, creator)
      challenges.each do |attr|
        type = attr.delete(:_type)
        challenge = type.constantize

        challenge = challenge.new(attr)
        challenge.creator = creator
        challenge.group = group
        challenge.save! unless group.challenges.where(title: attr[:title]).present?
      end
    end

    group = Group.where(name: 'Berlin').first
    challenges = [
      # challenge
      {
        title: 'I survived BVG',
        description: 'Arrive on time to your destination despite using piblic transport - five times in a row ',
        _type: 'TopChallenge', # SingleChallenge, PersonalChallenge, TopChallenge
        difficulty: 1, # easy, medium, hard
        #Berlin
      },
      # challenge
      {
        title: 'Round and Round',
        description: 'Complete a full circle around the city by the S41/42',
        _type: 'TopChallenge', # SingleChallenge, PersonalChallenge, TopChallenge
        difficulty: 1, # easy, medium, hard
        #Berlin
      },
      # challenge
      {
        title: 'Know your city',
        description: 'Visit every district of Berlin on a single day',
        _type: 'SingleChallenge', # SingleChallenge, PersonalChallenge, TopChallenge
        difficulty: 2, # easy, medium, hard
        #Berlin
      }
    ]
    create_challenges(group, challenges, creator)

    falk = User.create!({
      email: 'falk.koeppe@infopark.de',
      title: 'Falk',
    }) rescue User.where(email: 'falk.koeppe@infopark.de').first

    group = Group.where(name: 'The Avengers').first
    challenges = [
      # challenge
      {
        title: 'Pentakill!',
        description: 'Catch 5 bad guys at once',
        _type: 'SingleChallenge', # SingleChallenge, PersonalChallenge, TopChallenge
        difficulty: 'medium', # easy, medium, hard
        #The Avengers
      },
      # challenge
      {
        title: 'Red = Dead?',
        description: 'I want Tony to tickle the Hulk. No suits allowed!',
        _type: 'PersonalChallenge', # SingleChallenge, PersonalChallenge, TopChallenge
        target_user: falk,
        difficulty: 'hard', # easy, medium, hard
        #The Avengers
      }
    ]
    create_challenges(group, challenges, creator)

    daddy = User.create!({
      email: 'john@yopmail.com',
      title: 'John',
    }) rescue User.where(email: 'john@yopmail.com').first

    group = Group.where(name: 'Family').first
    challenges = [
      # challenge
      {
        title: 'Wash the Dishes',
        description: 'Clean up the mess in the kitchen.',
        _type: 'SingleChallenge', # SingleChallenge, PersonalChallenge, TopChallenge
        difficulty: 'easy', # easy, medium, hard
        #Family
      },
      # challenge
      {
        title: 'An afternoon of football!',
        description: 'I want Daddy to play football with me',
        _type: 'PersonalChallenge', # SingleChallenge, PersonalChallenge, TopChallenge
        target_user: daddy,
        difficulty: 'easy', # easy, medium, hard
        #Family
      },
      # challenge
      {
        title: 'Trashy Job',
        description: 'Take away all the trash for a month',
        _type: 'SingleChallenge', # SingleChallenge, PersonalChallenge, TopChallenge
        difficulty: 'easy', # easy, medium, hard
        #Family
      },
    ]
    create_challenges(group, challenges, creator)


    group = Group.where(name: 'Fleet Street 23a').first
    challenges = [
      # challenge
      {
        title: 'The leaves are falling',
        description: 'It\'s autumn and someone has to clean up all the leaves in the backyard. Bonus cookies if done before it starts raining!',
        _type: 'SingleChallenge', # SingleChallenge, PersonalChallenge, TopChallenge
        difficulty: 'medium', # easy, medium, hard
        #Fleet Street 23a
      },
      # challenge
      {
        title: 'Code Milky Green',
        description: 'I am sick and need somebody to bring me some tea and other supplies',
        _type: 'TopChallenge', # SingleChallenge, PersonalChallenge, TopChallenge
        difficulty: 'easy', # easy, medium, hard
        #Fleet Street 23a
      },
    ]
    create_challenges(group, challenges, creator)

    group = Group.where(name: 'Ride more Bikes').first
    challenges = [
      # challenge
      {
        title: 'Care for your baby',
        description: 'Bikes need love too! Clean and oil yours',
        _type: 'TopChallenge', # SingleChallenge, PersonalChallenge, TopChallenge
        difficulty: 'medium', # easy, medium, hard
        #Ride more Bikes
      },
      # challenge
      {
        title: 'Call for Perseverance',
        description: 'Ride your bike to work/school/etc every day for a month. Yes, even though it\'s autumn.',
        _type: 'TopChallenge', # SingleChallenge, PersonalChallenge, TopChallenge
        difficulty: 'hard', # easy, medium, hard
        #Ride more Bikes
      },
      # challenge
      {
        title: 'Beat it',
        description: 'Beat your personal record time for your way to work',
        _type: 'TopChallenge', # SingleChallenge, PersonalChallenge, TopChallenge
        difficulty: 'hard', # easy, medium, hard
        #Ride more Bikes
      },
    ]
    create_challenges(group, challenges, creator)

    group = Group.where(name: 'Say no to Procrastination').first
    challenges = [
      # challenge
      {
        title: 'May the force be with you',
        description: 'If willpower only is not enough, you need to force yourself to work. Download a tool to restrict your internet usage.',
        _type: 'TopChallenge', # SingleChallenge, PersonalChallenge, TopChallenge
        difficulty: 'medium', # easy, medium, hard
        #Say no to Procrastination
      },
      # challenge
      {
        title: 'One day at a Time',
        description: 'You can do it - at least for one single day. And this day is today!',
        _type: 'TopChallenge', # SingleChallenge, PersonalChallenge, TopChallenge
        difficulty: 'medium', # easy, medium, hard
        #Say no to Procrastination
      },
      # challenge
      {
        title: 'Skeletons in the Closet',
        description: 'Do you know them, those tasks you meant to do since about 1997? Well, the time is now: Finish a task you wanted to do for a long time.',
        _type: 'TopChallenge', # SingleChallenge, PersonalChallenge, TopChallenge
        difficulty: 'hard', # easy, medium, hard
        #Say no to Procrastination
      },
    ]
    create_challenges(group, challenges, creator)

    group = Group.where(name: 'The Dark Side').first
    challenges = [# challenge
      {
        title: 'Cookie Monster',
        description: 'Bake some cookies and share them with someone!',
        _type: 'SingleChallenge', # SingleChallenge, PersonalChallenge, TopChallenge
        difficulty: 'medium', # easy, medium, hard
        #The Dark Side
      },
      # challenge
      {
        title: 'Who wants to be a Jedi?',
        description: 'Play through any Star Wars game (KOTOR recommended)',
        _type: 'TopChallenge', # SingleChallenge, PersonalChallenge, TopChallenge
        difficulty: 'hard', # easy, medium, hard
        #The Dark Side
      }
    ]
    create_challenges(group, challenges, creator)

    group = Group.where(name: '2014 Winter Olypmics').first
    challenges = [
      # challenge
      {
        title: 'No Risk no Fun',
        description: 'Take a bet on a match in a discipline of your choice',
        _type: 'SingleChallenge', # SingleChallenge, PersonalChallenge, TopChallenge
        difficulty: 'easy', # easy, medium, hard
        #2014 Winter Olypmics
      },
      # challenge
      {
        title: 'Gotta watch them all',
        description: 'Watch at least one hour of tournaments every day',
        _type: 'TopChallenge', # SingleChallenge, PersonalChallenge, TopChallenge
        difficulty: 'medium', # easy, medium, hard
        #2014 Winter Olypmics
      }
    ]
    create_challenges(group, challenges, creator)

  end
end
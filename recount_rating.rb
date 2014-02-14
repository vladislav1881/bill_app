User.update_all(:rating => 0, robustness: 0)
Match.update_all(status: 'planned')
Match.all.reverse.each { |m| m.status = 'finished'; m.save }
User.where("robustness < 10").update_all(rating: 400)


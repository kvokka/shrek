# frozen_string_literal: true

class LeftIngredients < StandardError; end
class LeftEnv         < StandardError; end

Dish = Struct.new :state, :ingredients, :env do
  def initialize
    super
    self.state = :none
    self.ingredients = []
    self.env = {}
  end
end

class Entry < Shrek::Layers
  def call(dish)
    dish.state = :cooking
    next_layer.call dish
    raise LeftIngredients if dish.ingredients.any?
    raise LeftEnv         if dish.env.any?
    [dish]
  rescue StandardError => _e
    dish.state = :error
    [dish]
  end
end

class TakeSlugs < Shrek::Layers
  def call(dish)
    dish.ingredients << :slugs
    next_layer.call dish
    # put some rest slugs back
  rescue StandardError => e
    # put slugs back, log it if needed
    raise(e)
  end
end

class TakeWood < Shrek::Layers
  def call(dish)
    dish.env[:wood] = 42
    next_layer.call dish
  rescue StandardError => e
    dish.env.delete :wood
    raise(e)
  end
end

class MakeFire < Shrek::Layers
  def call(dish)
    raise(RuntimeError) unless env[:matches]
    state_was = dish.state
    dish.state = :twisted_firestarter
    # ...
    next_layer.call dish
    # ... some execution after, so you do not need callbacks!
    dish.state = state_was
    [dish]
  end
end

class CutShashimi < Shrek::Layers
  def call(dish, component: :slugs)
    raise unless dish.ingredients.include?(component)
    dish.ingredients.delete(component)
    dish.env[:masterpiece] = :slugs_shashimi
    next_layer.call dish
  end
end

class Eat < Shrek::Layers
  def call(dish)
    raise unless dish.env[:masterpiece]
    dish.env.delete :masterpiece
    dish.state = :belissimo
    # ...
    next_layer.call dish
    [dish]
  end
end

class UnreachableSteps < Shrek::Layers; end

class Awesome
  include Shrek

  def slugs_soup_recepe
    use_layers  Entry,
                TakeSlugs,
                TakeWood,
                MakeFire,
                UnreachableSteps
  end

  def slugs_shashimi_recepe
    use_layers  Entry,
                TakeSlugs,
                CutShashimi,
                Eat
  end
end

RSpec.describe Awesome do
  context 'Slugs soup' do
    subject { Awesome.new.slugs_soup_recepe.call(Dish.new).first }

    it('should be a Dish') { expect(subject).to be_a(Dish) }
    it('should return an error') { expect(subject.state).to eq(:error) }
  end

  context 'Slugs shashimi' do
    subject { Awesome.new.slugs_shashimi_recepe.call(Dish.new).first }

    it('should be a Dish') { expect(subject).to be_a(Dish) }
    it('should be belissimo') { expect(subject.state).to eq(:belissimo) }
  end
end

RSpec.describe Shrek do
  subject { Shrek[Entry, TakeSlugs, CutShashimi, Eat].call(Dish.new).first }
  it('should be belissimo') { expect(subject.state).to eq(:belissimo) }
end

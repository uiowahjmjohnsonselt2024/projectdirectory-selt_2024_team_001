class StorefrontController < ActionController::Base
  before_action :set_user_gold

  # Main store menu
  def store_menu
    # Combine items from all categories
    all_items = [
      # Ships
      { title: "Ship 1", description: "A fast and agile ship.", cost: 100 },
      { title: "Ship 2", description: "A durable and powerful ship.", cost: 200 },
      { title: "Ship 3", description: "A balanced ship for exploration.", cost: 150 },
      { title: "Ship 4", description: "A sleek ship for speed enthusiasts.", cost: 250 },
      { title: "Ship 5", description: "A heavy ship equipped with strong armor.", cost: 300 },
      { title: "Ship 6", description: "A heavy ship equipped with strong armor.", cost: 300 },


      # Modules
      { title: "Module 1", description: "Increases speed by 20%.", cost: 100 },
      { title: "Module 2", description: "Enhances durability by 15%.", cost: 150 },
      { title: "Module 3", description: "Boosts firepower significantly.", cost: 200 },
      { title: "Module 4", description: "Improves energy efficiency for long journeys.", cost: 120 },
      { title: "Module 5", description: "Adds stealth capabilities.", cost: 180 },
      { title: "Ship 5", description: "A heavy ship equipped with strong armor.", cost: 300 },


      # Crew
      { title: "Captain", description: "Experienced leader who commands the ship.", cost: 300 },
      { title: "Engineer", description: "Ensures the ship operates smoothly.", cost: 200 },
      { title: "Pilot", description: "Master navigator and combat specialist.", cost: 250 },
      { title: "Medic", description: "Keeps the crew in top physical condition.", cost: 150 },
      { title: "Scientist", description: "Conducts research and enhances technology.", cost: 350 },
      { title: "Ship 5", description: "A heavy ship equipped with strong armor.", cost: 300 },


      # Consumables
      { title: "Health Pack", description: "Restores 50% of maximum health.", cost: 50 },
      { title: "Energy Cell", description: "Refills energy reserves for extended travel.", cost: 75 },
      { title: "Shield Booster", description: "Temporarily enhances shields by 25%.", cost: 100 },
      { title: "Combat Stimulant", description: "Increases combat performance for a short duration.", cost: 125 },
      { title: "Repair Kit", description: "Repairs minor hull damage on the ship.", cost: 90 },
      { title: "Ship 5", description: "A heavy ship equipped with strong armor.", cost: 300 },
    ]

    # Filter items based on the search query
    @filtered_items = if params[:search].present?
                        all_items.select do |item|
                          item[:title].downcase.include?(params[:search].downcase) ||
                            item[:description].downcase.include?(params[:search].downcase)
                        end
                      else
                        []
                      end
  end

  # Ships category
  def ships
    @items = filter_items([
                            { title: "Ship 1", description: "A fast and agile ship.", cost: 100 },
                            { title: "Ship 2", description: "A durable and powerful ship.", cost: 200 },
                            { title: "Ship 3", description: "A balanced ship for exploration.", cost: 150 },
                            { title: "Ship 4", description: "A sleek ship for speed enthusiasts.", cost: 250 },
                            { title: "Ship 5", description: "A heavy ship equipped with strong armor.", cost: 300 },
                            { title: "Ship 5", description: "A heavy ship equipped with strong armor.", cost: 300 }
                          ])
  end

  # Modules category
  def modules
    @items = filter_items([
                            { title: "Module 1", description: "Increases speed by 20%.", cost: 100 },
                            { title: "Module 2", description: "Enhances durability by 15%.", cost: 150 },
                            { title: "Module 3", description: "Boosts firepower significantly.", cost: 200 },
                            { title: "Module 4", description: "Improves energy efficiency for long journeys.", cost: 120 },
                            { title: "Module 5", description: "Adds stealth capabilities.", cost: 180 },
                            { title: "Ship 5", description: "A heavy ship equipped with strong armor.", cost: 300 }
                          ])
  end

  # Crew category
  def crew
    @items = filter_items([
                            { title: "Captain", description: "Experienced leader who commands the ship.", cost: 300 },
                            { title: "Engineer", description: "Ensures the ship operates smoothly.", cost: 200 },
                            { title: "Pilot", description: "Master navigator and combat specialist.", cost: 250 },
                            { title: "Medic", description: "Keeps the crew in top physical condition.", cost: 150 },
                            { title: "Scientist", description: "Conducts research and enhances technology.", cost: 350 },
                            { title: "Ship 5", description: "A heavy ship equipped with strong armor.", cost: 300 }
                          ])
  end

  # Consumables category
  def consumables
    @items = filter_items([
                            { title: "Health Pack", description: "Restores 50% of maximum health.", cost: 50 },
                            { title: "Energy Cell", description: "Refills energy reserves for extended travel.", cost: 75 },
                            { title: "Shield Booster", description: "Temporarily enhances shields by 25%.", cost: 100 },
                            { title: "Combat Stimulant", description: "Increases combat performance for a short duration.", cost: 125 },
                            { title: "Repair Kit", description: "Repairs minor hull damage on the ship.", cost: 90 },
                            { title: "Ship 5", description: "A heavy ship equipped with strong armor.", cost: 300 }
                          ])
  end

  def trade
    #logic
  end

  # Handles the gold update when a player purchases an item
  def update_gold
    gold_spent = params[:gold_spent].to_i
    if current_user.gold >= gold_spent
      current_user.gold -= gold_spent
      current_user.save
      render json: { status: 'success', new_gold: current_user.gold }
    else
      render json: { status: 'error', message: 'Not enough gold' }, status: :unprocessable_entity
    end
  end

  private

  # Sets the user's current gold for display
  def set_user_gold
    #@gold = current_user.gold
    @gold = 1000
  rescue NoMethodError
    @gold = 0 # Default to 0 if current_user is not available
  end

  # Filters items based on the search query
  def filter_items(items)
    if params[:search].present?
      items.select do |item|
        item[:title].downcase.include?(params[:search].downcase) ||
          item[:description].downcase.include?(params[:search].downcase)
      end
    else
      items
    end
  end
end

# ./vendor/bin/behat -c tests/Integration/Behaviour/behat.yml -s product --tags generate-combinations
@reset-database-before-feature
@clear-cache-before-feature
@product-combination
@generate-combinations
Feature: Generate attribute combinations for product in Back Office (BO)
  As an employee
  I need to be able to generate product attribute combinations from BO

  Background:
    Given language with iso code "en" is the default one
    And attribute group "Size" named "Size" in en language exists
    And attribute group "Color" named "Color" in en language exists
    And attribute "S" named "S" in en language exists
    And attribute "M" named "M" in en language exists
    And attribute "L" named "L" in en language exists
    And attribute "White" named "White" in en language exists
    And attribute "Black" named "Black" in en language exists
    And attribute "Blue" named "Blue" in en language exists
    And attribute "Red" named "Red" in en language exists

  Scenario: Generate product combinations
    When I add product "product1" with following information:
      | name[en-US] | universal T-shirt |
      | type        | combinations      |
    Then product product1 type should be combinations
    And product product1 does not have a default combination
    When I generate combinations for product product1 using following attributes:
      | Size  | [S,M]              |
      | Color | [White,Black,Blue] |
    Then product "product1" should have following combinations:
      | id reference   | combination name        | reference | attributes           | impact on price | quantity | is default |
      | product1SWhite | Size - S, Color - White |           | [Size:S,Color:White] | 0               | 0        | true       |
      | product1SBlack | Size - S, Color - Black |           | [Size:S,Color:Black] | 0               | 0        | false      |
      | product1SBlue  | Size - S, Color - Blue  |           | [Size:S,Color:Blue]  | 0               | 0        | false      |
      | product1MWhite | Size - M, Color - White |           | [Size:M,Color:White] | 0               | 0        | false      |
      | product1MBlack | Size - M, Color - Black |           | [Size:M,Color:Black] | 0               | 0        | false      |
      | product1MBlue  | Size - M, Color - Blue  |           | [Size:M,Color:Blue]  | 0               | 0        | false      |
    And product product1 default combination should be "product1SWhite"
    When I list attribute groups for product product1 I should get following results:
      | name[en-US] | public_name[en-US] | is_color_group | group_type | position | reference  |
      | Size        | Size               | false          | select     | 0        | Size       |
      | Color       | Color              | true           | color      | 1        | Color      |
    When I list attribute groups for product "product1", the group "Size" should have the following attributes:
      | name[en-US] | color | position | reference |
      | S           |       | 0        | S         |
      | M           |       | 1        | M         |
    When I list attribute groups for product "product1", the group "Color" should have the following attributes:
      | name[en-US] | color   | position | reference |
      | White       | #ffffff | 3        | White     |
      | Black       | #434A54 | 6        | Black     |
      | Blue        | #5D9CEC | 9        | Blue      |

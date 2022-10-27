describe("product page", ()=>{

  beforeEach(() => {
    cy.visit('http://localhost:3000')
  })

  it("Should be able to add item to cart", ()=>{
    cy.get("#navbarSupportedContent .fa")
    cy.contains("My Cart (0)")

    cy.get(".btn").first().click({force: true})
    cy.contains("My Cart (1)")
  })

})
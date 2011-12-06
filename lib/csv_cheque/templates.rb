class Template
  BANKS = {
    default: { # citibank
      options: {
        date: {
          position: [1.0, 12.5]
        },
        payee: {
          position: [1.4, 0.5],
          dimensions: [9.5, 1.5]
        },
        amount_text: {
          position: [3.4, 1.5],
          dimensions: [8.2, 1.5]
        },
        amount_number: {
          position: [3.4, 12.0]
        }
      },
      lines: {
        cross: {
          start: [2.0 , 0],
          end: [0.0, 2.0]
        },
        bearer: {
          start: [3.15, 11.1],
          end: [3.15, 12.3]
        }
      }
    }
  }
end
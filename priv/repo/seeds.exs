# Script for popular o banco de dados
# priv/repo/seeds.exs

alias DigistabStore.Repo
alias DigistabStore.Store.{Status, Category, TagType, Tag, Product, ProductPhoto}

# Clean existing data - don't use this seed file in prod
Repo.delete_all(ProductPhoto)
Repo.delete_all(Product)
Repo.delete_all(Tag)
Repo.delete_all(TagType)
Repo.delete_all(Category)
Repo.delete_all(Status)

# Seeds for Status
statuses = [
  %{
    name: "Active",
    description: "Product is available for purchase"
  },
  %{
    name: "Out of Stock",
    description: "Product is temporarily unavailable"
  },
  %{
    name: "Discontinued",
    description: "Product is no longer being sold"
  },
  %{
    name: "Coming Soon",
    description: "Product will be available in the future"
  }
]

status_entries =
  Enum.map(
    statuses,
    &Repo.insert!(%Status{
      name: &1.name,
      description: &1.description
    })
  )

# Seeds for Categories
categories = [
  %{
    name: "Electronics",
    description: "Electronic devices and accessories"
  },
  %{
    name: "Books",
    description: "Physical and digital books"
  },
  %{
    name: "Clothing",
    description: "Apparel and accessories"
  },
  %{
    name: "Home & Garden",
    description: "Items for home and garden"
  },
  %{
    name: "Sports",
    description: "Sports equipment and accessories"
  }
]

category_entries =
  Enum.map(
    categories,
    &Repo.insert!(%Category{
      name: &1.name,
      description: &1.description
    })
  )

# Seeds for TagTypes
tag_types = [
  %{name: "Color"},
  %{name: "Size"},
  %{name: "Material"},
  %{name: "Brand"},
  %{name: "Season"}
]

tag_type_entries =
  Enum.map(
    tag_types,
    &Repo.insert!(%TagType{
      name: &1.name
    })
  )

# Seeds for Tags
tags = [
  # Colors
  %{name: "Red", tag_type_id: Enum.at(tag_type_entries, 0).id},
  %{name: "Blue", tag_type_id: Enum.at(tag_type_entries, 0).id},
  %{name: "Green", tag_type_id: Enum.at(tag_type_entries, 0).id},
  %{name: "Black", tag_type_id: Enum.at(tag_type_entries, 0).id},
  # Sizes
  %{name: "Small", tag_type_id: Enum.at(tag_type_entries, 1).id},
  %{name: "Medium", tag_type_id: Enum.at(tag_type_entries, 1).id},
  %{name: "Large", tag_type_id: Enum.at(tag_type_entries, 1).id},
  # Materials
  %{name: "Cotton", tag_type_id: Enum.at(tag_type_entries, 2).id},
  %{name: "Leather", tag_type_id: Enum.at(tag_type_entries, 2).id},
  %{name: "Plastic", tag_type_id: Enum.at(tag_type_entries, 2).id},
  # Brands
  %{name: "Nike", tag_type_id: Enum.at(tag_type_entries, 3).id},
  %{name: "Adidas", tag_type_id: Enum.at(tag_type_entries, 3).id},
  %{name: "Samsung", tag_type_id: Enum.at(tag_type_entries, 3).id},
  # Seasons
  %{name: "Summer", tag_type_id: Enum.at(tag_type_entries, 4).id},
  %{name: "Winter", tag_type_id: Enum.at(tag_type_entries, 4).id},
  %{name: "All Season", tag_type_id: Enum.at(tag_type_entries, 4).id}
]

tag_entries =
  Enum.map(
    tags,
    &Repo.insert!(%Tag{
      name: &1.name,
      tag_type_id: &1.tag_type_id
    })
  )

# Seeds for Products
products = [
  %{
    name: "Smart TV 55\"",
    description:
      "Experience the ultimate in smart TV technology with this Roku 50\" Onn 4K UHD OLED TV. With access to the Appstore and downloadable apps, this TV is perfect for streaming your favorite movies and TV shows. ",
    price: 299_000,
    promotional_price: 279_990,
    stock: 15,
    # Active
    status_id: Enum.at(status_entries, 1).id,
    # Electronics
    category_id: Enum.at(category_entries, 0).id,
    featured?: true,
    tags: [
      Enum.find(tag_entries, &(&1.name == "Samsung")),
      Enum.find(tag_entries, &(&1.name == "All Season"))
    ]
  },
  %{
    name: "Running Shoes Pro",
    description: "Adidas Adizero Adios Pro 3 Running Shoes.",
    price: 12000,
    promotional_price: 0,
    stock: 50,
    status_id: Enum.at(status_entries, 2).id,
    # Sports
    category_id: Enum.at(category_entries, 4).id,
    featured?: true,
    tags: [
      Enum.find(tag_entries, &(&1.name == "Nike")),
      Enum.find(tag_entries, &(&1.name == "All Season")),
      Enum.find(tag_entries, &(&1.name == "Medium"))
    ]
  },
  %{
    name: "Summer Cotton T-Shirt",
    description:
      "Unisex Style T-Shirt for the best fit, feel and durability. True to size with a standard fit.",
    price: 2000,
    promotional_price: 2400,
    stock: 100,
    status_id: Enum.at(status_entries, 3).id,
    # Clothing
    category_id: Enum.at(category_entries, 2).id,
    featured?: false,
    tags: [
      Enum.find(tag_entries, &(&1.name == "Cotton")),
      Enum.find(tag_entries, &(&1.name == "Summer")),
      Enum.find(tag_entries, &(&1.name == "Blue"))
    ]
  },
  %{
    name: "Professional Garden Tools Set",
    description:
      "This amazing tool allows you to graft plants together and cut branches easily! Perfect for fruit trees or growing a beautiful garden!",
    price: 7000,
    promotional_price: 6999,
    stock: 0,
    # Out of Stock
    status_id: Enum.at(status_entries, 0).id,
    # Home & Garden
    category_id: Enum.at(category_entries, 3).id,
    featured?: false,
    tags: [
      Enum.find(tag_entries, &(&1.name == "All Season"))
    ]
  },
  %{
    name: "Modern Web Development Book",
    description: "Comprehensive guide to modenr web development practices and technologies",
    price: 4000,
    promotional_price: 4400,
    stock: 30,
    status_id: Enum.at(status_entries, 0).id,
    # Books
    category_id: Enum.at(category_entries, 1).id,
    featured?: true,
    tags: [
      Enum.find(tag_entries, &(&1.name == "All Season"))
    ]
  },
  %{
    name: "Wireless Earbuds Pro",
    description:
      "EarFun Air Pro 3 Wireless Earbuds, Noise Cancelling Headphones, 6 Mics, 45 Hr .",
    price: 15000,
    promotional_price: 0,
    stock: 25,
    status_id: Enum.at(status_entries, 0).id,
    # Electronics
    category_id: Enum.at(category_entries, 0).id,
    featured?: true,
    tags: [
      Enum.find(tag_entries, &(&1.name == "Samsung")),
      Enum.find(tag_entries, &(&1.name == "Black"))
    ]
  },
  %{
    name: "Fitness Smartwatch",
    description:
      "Calendar, Alarm Clock, Power Reserve, Countdown, Sleep Tracker, Fitness Tracker, Passometer, Call Reminder, Answer Call, and much more.",
    price: 24000,
    promotional_price: 19000,
    stock: 40,
    status_id: Enum.at(status_entries, 2).id,
    # Electronics
    category_id: Enum.at(category_entries, 0).id,
    featured?: true,
    tags: [
      Enum.find(tag_entries, &(&1.name == "Samsung")),
      Enum.find(tag_entries, &(&1.name == "All Season"))
    ]
  },
  %{
    name: "Premium Yoga Mat",
    description: "Extra thick, non-slip yoga mat with alignment marks",
    price: 4000,
    promotional_price: 3000,
    stock: 60,
    status_id: Enum.at(status_entries, 2).id,
    # Sports
    category_id: Enum.at(category_entries, 4).id,
    featured?: false,
    tags: [
      Enum.find(tag_entries, &(&1.name == "Blue")),
      Enum.find(tag_entries, &(&1.name == "All Season"))
    ]
  },
  %{
    name: "Winter Expedition Jacket",
    description: "Heavy-duty waterprooof winter jacket with thermal lining",
    price: 19000,
    promotional_price: 0,
    stock: 0,
    # Out of Stock
    status_id: Enum.at(status_entries, 1).id,
    # Clothing
    category_id: Enum.at(category_entries, 2).id,
    featured?: false,
    tags: [
      Enum.find(tag_entries, &(&1.name == "Winter")),
      Enum.find(tag_entries, &(&1.name == "Large"))
    ]
  },
  %{
    name: "Mystery Detective Collection",
    description:
      "Collection of bestselling mystery and detective novels, with Agatha Christie and Sherlock books.",
    price: 5000,
    promotional_price: 4000,
    stock: 75,
    status_id: Enum.at(status_entries, 0).id,
    # Books
    category_id: Enum.at(category_entries, 1).id,
    featured?: false,
    tags: [
      Enum.find(tag_entries, &(&1.name == "All Season"))
    ]
  },
  %{
    name: "Gaming Laptop Elite",
    description: "High-performance gaming laptop with RTX 3060 graphics and RGB keyboard",
    price: 499_000,
    promotional_price: 449_000,
    stock: 10,
    status_id: Enum.at(status_entries, 3).id,
    # Electronics
    category_id: Enum.at(category_entries, 0).id,
    featured?: true,
    tags: [
      Enum.find(tag_entries, &(&1.name == "Samsung")),
      Enum.find(tag_entries, &(&1.name == "All Season"))
    ]
  },
  %{
    name: "Indoor Plant Collection",
    description:
      "Set of low-maintenance indoor plants perfect for home decoration, your puppies will love it.",
    price: 8000,
    promotional_price: 7000,
    stock: 20,
    status_id: Enum.at(status_entries, 1).id,
    # Home & Garden
    category_id: Enum.at(category_entries, 3).id,
    featured?: true,
    tags: [
      Enum.find(tag_entries, &(&1.name == "All Season"))
    ]
  },
  %{
    name: "Professional Basketball",
    description: "Official size professional basketball with superior grip, by Michael Jordan.",
    price: 3000,
    promotional_price: 2000,
    stock: 45,
    status_id: Enum.at(status_entries, 0).id,
    # Sports
    category_id: Enum.at(category_entries, 4).id,
    featured?: false,
    tags: [
      Enum.find(tag_entries, &(&1.name == "Nike")),
      Enum.find(tag_entries, &(&1.name == "All Season"))
    ]
  },
  %{
    name: "Ergonomic Office Chair",
    description: "Premium ergonomic office chair with adjustable lumbar support",
    price: 29000,
    promotional_price: 0,
    stock: 15,
    status_id: Enum.at(status_entries, 0).id,
    # Home & Garden
    category_id: Enum.at(category_entries, 3).id,
    featured?: false,
    tags: [
      Enum.find(tag_entries, &(&1.name == "Black")),
      Enum.find(tag_entries, &(&1.name == "All Season"))
    ]
  },
  %{
    name: "Wireless Gaming Mouse",
    description:
      "High-precision wireless gaming mouse with programmable buttons, a perfect set of options and settings by Logitech.",
    price: 5000,
    promotional_price: 4000,
    stock: 30,
    status_id: Enum.at(status_entries, 0).id,
    # Electronics
    category_id: Enum.at(category_entries, 0).id,
    featured?: true,
    tags: [
      Enum.find(tag_entries, &(&1.name == "Black")),
      Enum.find(tag_entries, &(&1.name == "All Season"))
    ]
  }
]

product_entries =
  Enum.map(
    products,
    &(%Product{}
      |> Product.changeset(&1)
      |> Repo.insert!())
  )

product_photos = [
  # Smart TV 55"
  %{
    url: "https://images.unsplash.com/photo-1593359677879-a4bb92f829d1",
    description: "Smart TV front view",
    main?: true,
    product_id: Enum.at(product_entries, 0).id
  },
  %{
    url: "https://images.unsplash.com/photo-1567690187548-f07b1d7bf5a9",
    description: "ports and connections",
    main?: false,
    product_id: Enum.at(product_entries, 0).id
  },
  %{
    url: "https://images.unsplash.com/photo-1461151304267-38535e780c79",
    description: "streaming apps",
    main?: false,
    product_id: Enum.at(product_entries, 0).id
  },
  # Running Shoes Pro
  %{
    url: "https://images.unsplash.com/photo-1542291026-7eec264c27ff",
    main?: true,
    product_id: Enum.at(product_entries, 1).id
  },
  %{
    url: "https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a",
    main?: false,
    product_id: Enum.at(product_entries, 1).id
  },
  %{
    url: "https://images.unsplash.com/photo-1581093458791-9f3c3900aa90",
    description: "Close-up of shoe sole and traction pattern",
    main?: false,
    product_id: Enum.at(product_entries, 1).id
  },
  %{
    url: "https://images.unsplash.com/photo-1539185441755-769473a23570",
    main?: false,
    product_id: Enum.at(product_entries, 1).id
  },
  # Summer Cotton T-Shirt
  %{
    url: "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab",
    description: "T-shirt front view on model",
    main?: true,
    product_id: Enum.at(product_entries, 2).id
  },
  %{
    url: "https://images.unsplash.com/photo-1583743814966-8936f5b7be1a",
    description: "T-shirt back view",
    main?: false,
    product_id: Enum.at(product_entries, 2).id
  },
  # Garden Tools Set
  %{
    url: "https://images.unsplash.com/photo-1416879595882-3373a0480b5b",
    description: "Professional garden tools set",
    main?: true,
    product_id: Enum.at(product_entries, 3).id
  },
  # Web Development Book
  %{
    url: "https://images.unsplash.com/photo-1532012197267-da84d127e765",
    description: "Programming book with laptop",
    main?: true,
    product_id: Enum.at(product_entries, 4).id
  },
  # Wireless Earbuds Pro
  %{
    url: "https://images.unsplash.com/photo-1590658268037-6bf12165a8df",
    description: "Earbuds in charging case",
    main?: true,
    product_id: Enum.at(product_entries, 5).id
  },
  %{
    url: "https://images.unsplash.com/photo-1631867675167-90a456a90863",
    main?: false,
    product_id: Enum.at(product_entries, 5).id
  },
  # Fitness Smartwatch X1
  %{
    url: "https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1",
    description: "Smart watch",
    main?: true,
    product_id: Enum.at(product_entries, 6).id
  },
  # Premium Yoga Mat
  %{
    url: "https://images.unsplash.com/photo-1592432678016-e910b452f9a2",
    main?: true,
    product_id: Enum.at(product_entries, 7).id
  },
  # Winter Expedition Jacket
  %{
    url: "https://images.unsplash.com/photo-1544923246-77307dd654cb",
    main?: true,
    product_id: Enum.at(product_entries, 8).id
  },
  # Mystery Detective Collection
  %{
    url: "https://images.unsplash.com/photo-1476275466078-4007374efbbe",
    description: "Collection of mystery books",
    main?: true,
    product_id: Enum.at(product_entries, 9).id
  },
  # Gaming Laptop Elite
  %{
    url: "https://images.unsplash.com/photo-1603302576837-37561b2e2302",
    description: "Gaming laptop with RGB keyboard",
    main?: true,
    product_id: Enum.at(product_entries, 10).id
  },
  # Indoor Plant Collection
  %{
    url: "https://images.unsplash.com/photo-1463320726281-696a485928c7",
    main?: true,
    product_id: Enum.at(product_entries, 11).id
  },
  # Professional Basketball
  %{
    url: "https://images.unsplash.com/photo-1519861531473-9200262188bf",
    main?: true,
    product_id: Enum.at(product_entries, 12).id
  },
  # Ergonomic Office Chair
  %{
    url: "https://images.unsplash.com/photo-1589384267710-7a25bc24e2d6",
    main?: true,
    product_id: Enum.at(product_entries, 13).id
  },
  # Wireless Gaming Mouse
  %{
    url: "https://images.unsplash.com/photo-1527814050087-3793815479db",
    description: "Gaming mouse",
    main?: true,
    product_id: Enum.at(product_entries, 14).id
  },
  %{
    url: "https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7",
    main?: false,
    product_id: Enum.at(product_entries, 14).id
  },
  %{
    url: "https://images.unsplash.com/photo-1629429408209-1f912961dbd8",
    main?: false,
    product_id: Enum.at(product_entries, 14).id
  }
]

Enum.each(
  product_photos,
  &Repo.insert!(%ProductPhoto{
    url: &1.url,
    description:
      if(Map.has_key?(&1, :description)) do
        &1.description
      else
        ""
      end,
    main?:
      if(Map.has_key?(&1, :main)) do
        &1.main
      else
        false
      end,
    product_id: &1.product_id
  })
)

# Log results
IO.puts("""

Seeds created successfully:
-------------------------
#{Enum.count(status_entries)} statuses
#{Enum.count(category_entries)} categories
#{Enum.count(tag_type_entries)} tag types
#{Enum.count(tag_entries)} tags
#{Enum.count(product_entries)} products
#{Enum.count(product_photos)} product photos
""")

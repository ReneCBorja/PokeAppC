//
//  PokemonListViewController.swift
//  PokeApp
//
//  Created by Rene B. on 12/4/26.
//

import UIKit
import Combine
import SwiftUI

final class PokemonListViewController: UIViewController {

    private let viewModel: PokemonListViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI
    private let searchBar = CustomSearchBar()
    private var collectionView: UICollectionView!
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let headerStack = UIStackView()
    // MARK: - INIT
    init(viewModel: PokemonListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

      //  title = "Pokédex"
        view.backgroundColor = .customLightGray

        setupHeader()
        setupCollectionView()
        bindViewModel()
        setupHideKeyboardGesture()

    }
    
    private func setupHideKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}



// MARK: - UI SETUP
private extension PokemonListViewController {

    func setupHeader() {
       

        searchBar.textField.addTarget(self, action: #selector(searchChanged), for: .editingChanged)
        
        // LOGO
        logoImageView.image = UIImage(named: "navBarIcon") // agrega tu imagen a Assets
        logoImageView.contentMode = .scaleAspectFit

        // TÍTULO
        let text = "!Hola, bienvenido!"

        let attributedString = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: UIFont.systemFont(ofSize: 24)
            ]
        )

        if let range = text.range(of: "bienvenido") {
            let nsRange = NSRange(range, in: text)
            
            let boldFont = UIFont.boldSystemFont(ofSize: 24)
            
            attributedString.addAttribute(.font, value: boldFont, range: nsRange)
        }

        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = .left
        titleLabel.textColor = .customBlack
        // SEARCH
        
        // STACK
        let stack = UIStackView(arrangedSubviews: [
            logoImageView,
            titleLabel,
            searchBar
        ])

        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .fill

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        // Altura del logo
        logoImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true

        // Altura search
        searchBar.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    @objc private func searchChanged() {
        viewModel.searchText = searchBar.textField.text ?? ""
    }
    
    func setupCollectionView() {

        let layout = UICollectionViewFlowLayout()

        let spacing: CGFloat = 10
        let width = (UIScreen.main.bounds.width - spacing * 3) / 2
        
        layout.itemSize = CGSize(width: width, height: width + 30)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(
            PokemonGridCell.self,
            forCellWithReuseIdentifier: "PokemonGridCell"
        )

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .customLightGray

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.subviews.first!.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
}

// MARK: - VIEWMODEL BINDING
private extension PokemonListViewController {

    func bindViewModel() {

        Publishers.CombineLatest(viewModel.$pokemons, viewModel.$searchText)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _, _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - COLLECTION VIEW DATA SOURCE
extension PokemonListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.filtered.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PokemonGridCell",
            for: indexPath
        ) as! PokemonGridCell

        let pokemon = viewModel.filtered[indexPath.item]
        cell.configure(with: pokemon)

        return cell
    }
}

// MARK: - COLLECTION VIEW DELEGATE (NAVIGATION)
extension PokemonListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let pokemon = viewModel.filtered[indexPath.item]

        let repo = PokemonRepositoryImpl()

        let detailView = PokemonDetailView(id: pokemon.id, repo: repo)
        let vc = UIHostingController(rootView: detailView)
        vc.navigationItem.hidesBackButton = true

        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

          vc.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)

        // TITLE (nombre)
        let titleLabel = UILabel()
        titleLabel.text = pokemon.name.capitalized
        titleLabel.textColor = .customBlueDark
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)

        // ID (#001)
        let idLabel = UILabel()
        idLabel.text = String(format: "#%03d", pokemon.id)
        idLabel.font = UIFont.systemFont(ofSize: 16)
        idLabel.textColor = .gray

        vc.navigationItem.titleView = titleLabel
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: idLabel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - SEARCH BAR
extension PokemonListViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
}

// MARK: - GRID CELL

final class PokemonGridCell: UICollectionViewCell {

    private let pokemonImage = UIImageView()
    private let nameLabel = UILabel()
    private let loader = UIActivityIndicatorView(style: .medium)
    private let idLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        pokemonImage.image = nil
        loader.startAnimating()
    }

    func configure(with pokemon: PokemonListItem) {

        nameLabel.text = pokemon.name.capitalized
        idLabel.text = String(format: "#%03d", pokemon.id)

        pokemonImage.image = nil
        loader.startAnimating()

        guard let url = pokemon.imageURL else {
            loader.stopAnimating()
            return
        }

        ImageLoader.shared.load(url) { [weak self] image in
            guard let self else { return }

            self.pokemonImage.image = image
            self.loader.stopAnimating()
        }
    }
   
    
    final class ImageLoader {
        static let shared = ImageLoader()

        private let cache = NSCache<NSURL, UIImage>()

        private init() {}

        func load(_ url: URL, completion: @escaping (UIImage?) -> Void) {

            if let cached = cache.object(forKey: url as NSURL) {
                completion(cached)
                return
            }

            URLSession.shared.dataTask(with: url) { data, _, _ in

                guard let data, let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }

                self.cache.setObject(image, forKey: url as NSURL)

                DispatchQueue.main.async {
                    completion(image)
                }

            }.resume()
        }
    }

    private func setupUI() {

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true

        pokemonImage.contentMode = .scaleAspectFit

        nameLabel.textAlignment = .left
        nameLabel.font = .aronBlack(size: 18)
        nameLabel.textColor = .customBlueDark
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        idLabel.font = UIFont.systemFont(ofSize: 14)
        idLabel.textColor = .customGray3
        idLabel.textAlignment = .left
        loader.color = .customBlueDark
        loader.hidesWhenStopped = true

        // 🔥 IMPORTANTE: quitar stack y agregar todo manual
        contentView.addSubview(idLabel)
        contentView.addSubview(pokemonImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(loader)

        idLabel.translatesAutoresizingMaskIntoConstraints = false
        pokemonImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        loader.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            //  ID arriba izquierda
            idLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            idLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            // IMAGEN centrada
            pokemonImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pokemonImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pokemonImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            pokemonImage.heightAnchor.constraint(equalTo: pokemonImage.widthAnchor),

            //  NOMBRE abajo izquierda
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),

            //  LOADER centrado en imagen
            loader.centerXAnchor.constraint(equalTo: pokemonImage.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: pokemonImage.centerYAnchor)
        ])
    }
}


final class CustomSearchBar: UIView {

    let textField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        backgroundColor = .white
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.customGray2.cgColor
        clipsToBounds = true

        // IMPORTANTÍSIMO
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)

        // TEXT CONFIG
        textField.placeholder = "Buscar"
        textField.textColor = .customBlueDark
        textField.tintColor = .customBlueDark
        textField.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        textField.backgroundColor = .clear
        textField.borderStyle = .none

        // DEBUG (quita si quieres luego)
        textField.backgroundColor = .clear

        // LEFT PADDING
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
        textField.leftViewMode = .always

        // RIGHT ICON (tu custom)
        let icon = UIImageView(image: UIImage(named: "searchIcon"))
        icon.contentMode = .scaleAspectFit

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        icon.frame = CGRect(x: 10, y: 0, width: 18, height: 18)

        container.addSubview(icon)

        textField.rightView = container
        textField.rightViewMode = .always

        NSLayoutConstraint.activate([
       //     heightAnchor.constraint(equalToConstant: 50),

            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        layoutIfNeeded()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.becomeFirstResponder()
    }
}
    
    


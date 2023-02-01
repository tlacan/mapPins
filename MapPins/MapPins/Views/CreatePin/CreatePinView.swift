//
//  CreatePinView.swift
//  MapPins
//
//  Created by thomas lacan on 27/01/2023.
//

import SwiftUI
import StarRating
import ImagePickerView
import PhotosUI

struct CreatePinView: View {
    let engine: Engine

    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: CreatePinViewModel
    @State var showAddressAutocomplete: Bool = false
    @State var showCamera: Bool = false
    @State var showImageDetails: Bool = false
    @State var detailIndex = 0
    @State var starConfig = StarRatingConfiguration(borderWidth: 1.0, borderColor: Color.yellow, shadowColor: Color.clear)
    @State var imageWidth: CGFloat = 0
    @State private var selectedItems = [PhotosPickerItem]()

    init(engine: Engine) {
        self.engine = engine
        _viewModel = StateObject(wrappedValue: CreatePinViewModel(engine: engine, editedPin: engine.pinService.pins.responseArray?.first))

    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack(spacing: UIProperties.Padding.medium.rawValue) {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: UIProperties.Padding.small.rawValue) {
                            name()
                            address()
                            categories()
                            rating()
                            images()
                            EmptyView().frame(height: UIProperties.Padding.big.rawValue)
                        }.padding(UIProperties.Padding.medium.rawValue)
                    }.frame(maxHeight: .infinity)
                    Color.clear.frame(height: UIProperties.Padding.medium.rawValue * 1 + UIProperties.Button.height.rawValue)
                }.frame(maxHeight: .infinity)
                FooterGradient().offset(y: -UIProperties.Padding.medium.rawValue)
                saveButton().offset(y: -UIProperties.Padding.medium.rawValue)
            }
                .navigationDestination(isPresented: $showAddressAutocomplete) {
                    AddressSearchView { address in
                        withAnimation(.default) {
                            showAddressAutocomplete = false
                            viewModel.address = address
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(XCAsset.Colors.background.swiftUIColor, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        CloseButton {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        L10n.CreatePin.title.swiftUITitle()
                    }
                }
                .sheet(isPresented: $showCamera) {
                    ImagePickerView(sourceType: .camera) { image in
                        self.viewModel.selectedImages.append(image)
                    }
                }
                .sheet(isPresented: $showImageDetails) {
                    imageDetailsView()
                }
        }
    }

    @ViewBuilder func images() -> some View {
        VStack(alignment: .leading) {
            L10n.CreatePin.images.swiftUISectionHeader()
            VStack(alignment: .leading, spacing: 2) {
                ForEach(0..<viewModel.imageRows + 1, id: \.self) { row in
                    HStack(spacing: 2) {
                        ForEach(0..<3) { col in
                            if let image = viewModel.image(col: col, row: row) {
                                Button {
                                    withAnimation(.default) {
                                        detailIndex = row * 3 + col
                                        showImageDetails = true
                                    }
                                } label: {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: (UIScreen.main.bounds.width - (6 + UIProperties.Padding.medium.rawValue * 2)) / 3, height: 120)
                                        .clipped()
                                }
                            } else {
                                Spacer()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }.frame(maxWidth: .infinity)
            HStack {
                PhotosPicker(selection: $selectedItems, matching: .images) {
                    ButtonView(image: UIImage(systemName: "photo"), text: L10n.CreatePin.Image.library) {
                    }.disabled(true)
                }
                ButtonView(image: UIImage(systemName: "camera"), text: L10n.CreatePin.Image.camera) {
                    showCamera = true
                }
            }.frame(maxWidth: .infinity)
        }.onChange(of: selectedItems) { items in
            Task {
                for item in items {
                    if let imageData = try? await item.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                        viewModel.selectedImages.append(image)
                    }
                }
                selectedItems.removeAll()
            }
        }
    }

    @ViewBuilder func imageDetailsView() -> some View {
        NavigationView {
            TabView(selection: $detailIndex) {
                ForEach(0...viewModel.selectedImages.count - 1, id: \.self) { index in
                    Image(uiImage: viewModel.selectedImages[index])
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                }
            }
                .navigationBarTitleDisplayMode(.inline)
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .never))
                .toolbar(content: {
                    ToolbarItem(placement: .cancellationAction, content: {
                        CloseButton {
                            showImageDetails = false
                        }
                    })
                    ToolbarItem(placement: .bottomBar, content: {
                        ButtonView(image: UIImage(systemName: "trash"), text: L10n.General.delete) {
                            if viewModel.selectedImages.count == 1 {
                                showImageDetails = false
                                viewModel.selectedImages = []
                                return
                            }
                            let indexToDelete = detailIndex
                            if detailIndex == viewModel.selectedImages.count - 1 {
                                detailIndex -= 1
                            }
                            viewModel.selectedImages.remove(at: indexToDelete)
                        }
                    })
                })
        }
    }

    @ViewBuilder func name() -> some View {
        TextField(L10n.CreatePin.name, text: $viewModel.name)
            .font(FontFamily.Poppins.regular.swiftUIFont(size: UIProperties.TextSize.description.rawValue))
            .textFieldStyle(.roundedBorder)
            .textContentType(.givenName)
            .autocorrectionDisabled()
    }

    @ViewBuilder func address() -> some View {
        TextField(L10n.CreatePin.address, text: Binding(get: {
            if let address = viewModel.address {
                return "\(address.title) \(address.subtitle)"
            }
            return ""
        }, set: { _, _ in

        }))
        .font(FontFamily.Poppins.regular.swiftUIFont(size: UIProperties.TextSize.description.rawValue))
        .textFieldStyle(.roundedBorder)
        .textContentType(.givenName)
        .autocorrectionDisabled()
        .onTapGesture {
            withAnimation(.default) {
                showAddressAutocomplete = true
            }
        }
    }

    @ViewBuilder func rating() -> some View {
        VStack(alignment: .leading) {
            L10n.CreatePin.rate.swiftUISectionHeader()
            StarRating(initialRating: viewModel.rating ?? 0, configuration: $starConfig) { value in
                viewModel.rating = value
            }.frame(height: 70)
            VStack {
                if let rating = viewModel.rating {
                    String(format: "%.1f", rating).swiftUIDescription()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
    }

    @ViewBuilder func categories() -> some View {
        VStack(alignment: .leading) {
            L10n.CreatePin.category.swiftUISectionHeader()
            HStack {
                ForEach(PinCategory.allCases, id: \.self.rawValue) { category in
                    VStack {
                        if viewModel.category?.rawValue == category.rawValue {
                            Button(action: {
                                withAnimation(.default) {
                                    viewModel.category = nil
                                }
                            }) {
                                ZStack {
                                    Circle().fill(XCAsset.Colors.black.swiftUIColor)
                                    if let image = category.image {
                                        Image(uiImage: image)
                                            .renderingMode(.template)
                                            .foregroundColor( XCAsset.Colors.background.swiftUIColor)
                                    }
                                }
                            }
                        } else {
                            Button(action: {
                                withAnimation(.default) {
                                    viewModel.category = category
                                }
                            }) {
                                ZStack {
                                    Circle().fill(.clear)
                                    if let image = category.image {
                                        Image(uiImage: image)
                                            .renderingMode(.template)
                                            .foregroundColor( XCAsset.Colors.black.swiftUIColor)
                                    }
                                }
                            }
                        }
                    }.frame(maxWidth: .infinity)
                }
            }
            VStack {
                if let selectedCategory = viewModel.category {
                    selectedCategory.uiText.swiftUIDescription()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
    }

    @ViewBuilder func saveButton() -> some View {
        ButtonView(text: L10n.General.save) {
            viewModel.savePin()
        }.opacity(viewModel.formValid ? UIProperties.Opacity.enabled.rawValue : UIProperties.Opacity.disabled.rawValue)
            .disabled(!viewModel.formValid)
    }
}

class CreatePinViewModel: ObservableObject {
    let editedPin: PinModel?
    let engine: Engine

    @Published var name: String {
        didSet {
            updateFormValid()
        }
    }
    @Published var address: AddressAutocompleteModel? {
        didSet {
            updateFormValid()
        }
    }
    @Published var category: PinCategory? {
        didSet {
            updateFormValid()
        }
    }
    @Published var rating: Double?
    @Published var formValid = false
    @Published var selectedImages: [UIImage]

    init(engine: Engine, editedPin: PinModel?) {
        self.editedPin = editedPin
        self.engine = engine
        self.name = editedPin?.name ?? ""
        self.address = editedPin?.address
        self.category = editedPin?.category
        self.rating = editedPin?.rating
        self.selectedImages = editedPin?.images.compactMap({ UIImage(data: $0) }) ?? []
        updateFormValid()
    }

    func updateFormValid() {
        withAnimation(.default) {
            if name.isEmpty || address == nil || category == nil {
                formValid = false
                return
            }
            formValid = true
        }
    }

    var imageRows: Int {
        selectedImages.count % 3 == 0 ? selectedImages.count / 3 : (selectedImages.count / 3 + 1)
    }

    func image(col: Int, row: Int) -> UIImage? {
        let index = row * 3 + col
        if index < selectedImages.count {
            return selectedImages[index]
        }
        return nil
    }

    func savePin() {
        guard let address = address, let category = category else { return }
        let images = selectedImages.compactMap({ $0.pngData() })
        let newPin = PinModel(id: editedPin?.id ?? UUID(), name: name,
                              address: address, images: images, rating: rating, category: category)
        engine.pinService.savePin(newPin)
    }
}

struct CreatePinView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePinView(engine: Engine())
    }
}

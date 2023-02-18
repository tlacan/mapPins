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

struct CreateEditPinView: View {
    enum Context {
        case create
        case edit
    }

    @Environment(\.dismiss) var dismiss

    let engine: Engine
    let context: Context

    @StateObject var viewModel: CreateEditPinViewModel
    @StateObject var imagesViewModel: PinImagesViewModel

    @State var showAddressAutocomplete: Bool = false
    @State var starConfig = AppConstants.Star.configuration
    @State var imageWidth: CGFloat = 0
    @FocusState private var addressFocus: Bool

    struct ViewConstants {
        struct Rating {
            static let height: CGFloat = 70
        }
        struct Categories {
            static let imageSize: CGFloat = 26
            static let categorySize: CGFloat = 36
        }
    }

    init(engine: Engine, editedPin: PinModel?) {
        self.engine = engine
        context = editedPin == nil ? .create : .edit
        _viewModel = StateObject(wrappedValue: CreateEditPinViewModel(engine: engine, editedPin: editedPin))
        _imagesViewModel = StateObject(wrappedValue: PinImagesViewModel(pin: editedPin))
    }

    var body: some View {
        if #available(iOS 16, *) {
            body16()
        } else {
            body15()
        }
    }

    @available(iOS 16, *)
    @ViewBuilder func body16() -> some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                mainContent()
            }
            .modifier(CreateEditPinViewNavigationModifier(viewModel: viewModel, imagesViewModel: imagesViewModel, context: context))
                .navigationDestination(isPresented: $showAddressAutocomplete) {
                    AddressSearchView { address in
                        withAnimation(.default) {
                            showAddressAutocomplete = false
                            viewModel.address = address
                        }
                    }
                }
                .toolbarBackground(XCAsset.Colors.background.swiftUIColor, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
    }

    @ViewBuilder func body15() -> some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                NavigationLink(isActive: $showAddressAutocomplete) {
                    AddressSearchView { address in
                        withAnimation(.default) {
                            showAddressAutocomplete = false
                            viewModel.address = address
                        }
                    }
                } label: { EmptyView() }
                mainContent()
            }
            .modifier(CreateEditPinViewNavigationModifier(viewModel: viewModel, imagesViewModel: imagesViewModel, context: context))
                .sheet(isPresented: $imagesViewModel.showLibrary) {
                    ImagePickerView(sourceType: .photoLibrary) { image in
                        imagesViewModel.images.append(image)
                    }
                }
                .onAppear {
                    let appearance = UINavigationBarAppearance()
                    appearance.backgroundColor = XCAsset.Colors.background.color
                    UINavigationBar.appearance().standardAppearance = appearance
                    UINavigationBar.appearance().scrollEdgeAppearance = appearance
                }
        }
    }

    @ViewBuilder func mainContent() -> some View {
        VStack(spacing: AppConstants.Padding.medium.rawValue) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppConstants.Padding.small.rawValue) {
                    name()
                    address()
                    categories()
                    rating()
                    if #available(iOS 16, *) {
                        CreatePinImages16View(viewModel: imagesViewModel)
                    } else {
                        CreatePinImages15View(viewModel: imagesViewModel)
                    }
                    EmptyView().frame(height: AppConstants.Padding.big.rawValue)
                }.padding(AppConstants.Padding.medium.rawValue)
            }.frame(maxHeight: .infinity)
            Color.clear.frame(height: AppConstants.Padding.medium.rawValue * 1 + AppConstants.Button.height.rawValue)
        }.frame(maxHeight: .infinity)
        FooterGradient().offset(y: -AppConstants.Padding.medium.rawValue)
        HStack {
            if context == .edit {
                mapButton()
            }
            saveButton()
        }.offset(y: -AppConstants.Padding.medium.rawValue)
    }

    @ViewBuilder func name() -> some View {
        TextField(L10n.CreatePin.name, text: $viewModel.name)
            .font(FontFamily.Poppins.regular.swiftUIFont(size: AppConstants.TextSize.description.rawValue))
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
        }, set: { _, _ in }))
        .font(FontFamily.Poppins.regular.swiftUIFont(size: AppConstants.TextSize.description.rawValue))
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
            }.frame(height: ViewConstants.Rating.height)
            VStack {
                if let rating = viewModel.rating {
                    String(format: "%.1f", locale: Locale.current, rating).swiftUIDescription()
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
                        Button(action: {
                            withAnimation(.default) {
                                viewModel.category = viewModel.category?.rawValue == category.rawValue ? nil : category
                            }
                        }) {
                            ZStack {
                                Circle().fill(viewModel.category?.rawValue == category.rawValue ? XCAsset.Colors.black.swiftUIColor : .clear)
                                if let image = category.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .renderingMode(.template)
                                        .scaledToFit()
                                        .foregroundColor( viewModel.category?.rawValue == category.rawValue ? XCAsset.Colors.background.swiftUIColor : XCAsset.Colors.black.swiftUIColor)
                                        .frame(width: ViewConstants.Categories.imageSize, height: ViewConstants.Categories.imageSize)
                                }
                            }.frame(width: ViewConstants.Categories.categorySize, height: ViewConstants.Categories.categorySize)
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
            Task {
                await viewModel.savePin(images: imagesViewModel.images)
                dismiss()
            }
        }.opacity(viewModel.formValid ? AppConstants.Opacity.enabled.rawValue : AppConstants.Opacity.disabled.rawValue)
            .disabled(!viewModel.formValid)
    }

    @ViewBuilder func mapButton() -> some View {
        ButtonView(image: UIImage(systemName: "map"), text: L10n.EditPin.Button.viewOnMap) {
            dismiss()
            NotificationConstants.showPinOnMap.post(object: viewModel.editedPin)
        }
    }
}

struct CreateEditPinViewNavigationModifier: ViewModifier {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CreateEditPinViewModel
    @ObservedObject var imagesViewModel: PinImagesViewModel

    let context: CreateEditPinView.Context

    init(viewModel: CreateEditPinViewModel, imagesViewModel: PinImagesViewModel, context: CreateEditPinView.Context) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        _imagesViewModel = ObservedObject(wrappedValue: imagesViewModel)
        self.context = context
    }

    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $imagesViewModel.showImageDetails) {
                PinImagesDetailView(viewModel: imagesViewModel, deleteButton: true)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    if context == .create {
                        CloseButton {
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .principal) {
                    (viewModel.editedPin?.name ?? L10n.CreatePin.title).swiftUITitle()
                }
            }
            .sheet(isPresented: $imagesViewModel.showCamera) {
                ImagePickerView(sourceType: .camera) { image in
                    imagesViewModel.images.append(image)
                }
            }
            .onAppear {
                UIView.removeFocus()
            }
    }
}

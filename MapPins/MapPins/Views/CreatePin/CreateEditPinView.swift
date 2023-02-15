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
    @Environment(\.dismiss) var dismiss

    let engine: Engine

    @StateObject var viewModel: CreateEditPinViewModel
    @StateObject var imagesViewModel: PinImagesViewModel

    @State var showAddressAutocomplete: Bool = false
    @State var starConfig = UIProperties.Star.configuration
    @State var imageWidth: CGFloat = 0
    @FocusState private var addressFocus: Bool

    init(engine: Engine, editedPin: PinModel?) {
        self.engine = engine
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
                .modifier(CreateEditPinViewNavigationModifier(viewModel: viewModel, imagesViewModel: imagesViewModel))
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
                .modifier(CreateEditPinViewNavigationModifier(viewModel: viewModel, imagesViewModel: imagesViewModel))
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
        VStack(spacing: UIProperties.Padding.medium.rawValue) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: UIProperties.Padding.small.rawValue) {
                    name()
                    address()
                    categories()
                    rating()
                    if #available(iOS 16, *) {
                        CreatePinImages16View(viewModel: imagesViewModel)
                    } else {
                        CreatePinImages15View(viewModel: imagesViewModel)
                    }
                    EmptyView().frame(height: UIProperties.Padding.big.rawValue)
                }.padding(UIProperties.Padding.medium.rawValue)
            }.frame(maxHeight: .infinity)
            Color.clear.frame(height: UIProperties.Padding.medium.rawValue * 1 + UIProperties.Button.height.rawValue)
        }.frame(maxHeight: .infinity)
        FooterGradient().offset(y: -UIProperties.Padding.medium.rawValue)
        saveButton().offset(y: -UIProperties.Padding.medium.rawValue)
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
        }, set: { _, _ in }))
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
                                        .frame(width: 26, height: 26)
                                }
                            }.frame(width: 36, height: 36)
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
        }.opacity(viewModel.formValid ? UIProperties.Opacity.enabled.rawValue : UIProperties.Opacity.disabled.rawValue)
            .disabled(!viewModel.formValid)
    }
}

struct CreateEditPinViewNavigationModifier: ViewModifier {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CreateEditPinViewModel
    @ObservedObject var imagesViewModel: PinImagesViewModel

    init(viewModel: CreateEditPinViewModel, imagesViewModel: PinImagesViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        _imagesViewModel = ObservedObject(wrappedValue: imagesViewModel)
    }

    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $imagesViewModel.showImageDetails) {
                PinImagesDetailView(viewModel: imagesViewModel, deleteButton: true)
            }
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

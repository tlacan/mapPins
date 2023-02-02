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
    let engine: Engine

    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: CreateEditPinViewModel
    @State var showAddressAutocomplete: Bool = false
    @State var starConfig = StarRatingConfiguration(borderWidth: 1.0, borderColor: Color.yellow, shadowColor: Color.clear)
    @State var imageWidth: CGFloat = 0

    init(engine: Engine) {
        self.engine = engine
        _viewModel = StateObject(wrappedValue: CreateEditPinViewModel(engine: engine, editedPin: nil))

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
                .sheet(isPresented: $viewModel.showCamera) {
                    ImagePickerView(sourceType: .camera) { image in
                        self.viewModel.selectedImages.append(image)
                    }
                }
                .sheet(isPresented: $viewModel.showImageDetails) {
                    imageDetailsView()
                }
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
                .navigationBarTitleDisplayMode(.inline)
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
                .sheet(isPresented: $viewModel.showCamera) {
                    ImagePickerView(sourceType: .camera) { image in
                        self.viewModel.selectedImages.append(image)
                    }
                }
                .sheet(isPresented: $viewModel.showImageDetails) {
                    imageDetailsView()
                }
                .sheet(isPresented: $viewModel.showLibrary) {
                    ImagePickerView(sourceType: .photoLibrary) { image in
                        self.viewModel.selectedImages.append(image)
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
                        PinImages16View(viewModel: viewModel)
                    } else {
                        PinImages15View(viewModel: viewModel)
                    }
                    EmptyView().frame(height: UIProperties.Padding.big.rawValue)
                }.padding(UIProperties.Padding.medium.rawValue)
            }.frame(maxHeight: .infinity)
            Color.clear.frame(height: UIProperties.Padding.medium.rawValue * 1 + UIProperties.Button.height.rawValue)
        }.frame(maxHeight: .infinity)
        FooterGradient().offset(y: -UIProperties.Padding.medium.rawValue)
        saveButton().offset(y: -UIProperties.Padding.medium.rawValue)
    }

    @ViewBuilder func imageDetailsView() -> some View {
        NavigationView {
            TabView(selection: $viewModel.detailIndex) {
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
                            viewModel.showImageDetails = false
                        }
                    })
                    ToolbarItem(placement: .bottomBar, content: {
                        ButtonView(image: UIImage(systemName: "trash"), text: L10n.General.delete) {
                            if viewModel.selectedImages.count == 1 {
                                viewModel.showImageDetails = false
                                viewModel.selectedImages = []
                                return
                            }
                            let indexToDelete = viewModel.detailIndex
                            if viewModel.detailIndex == viewModel.selectedImages.count - 1 {
                                viewModel.detailIndex -= 1
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
                                            .resizable()
                                            .renderingMode(.template)
                                            .scaledToFit()
                                            .foregroundColor( XCAsset.Colors.background.swiftUIColor)
                                            .frame(width: 26, height: 26)
                                    }
                                }.frame(width: 36, height: 36)
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
                                            .resizable()
                                            .renderingMode(.template)
                                            .scaledToFit()
                                            .foregroundColor( XCAsset.Colors.black.swiftUIColor)
                                            .frame(width: 26, height: 26)
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
            Task {
                await viewModel.savePin()
            }
        }.opacity(viewModel.formValid ? UIProperties.Opacity.enabled.rawValue : UIProperties.Opacity.disabled.rawValue)
            .disabled(!viewModel.formValid)
    }
}

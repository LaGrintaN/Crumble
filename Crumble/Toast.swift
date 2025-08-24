import SwiftUI

// MARK: - Toast Style
enum ToastStyle {
    case success
    case error
    case info
    
    var backgroundColor: Color {
        switch self {
        case .success:
            return Color.green
        case .error:
            return Color.red
        case .info:
            return Color.blue
        }
    }
    
    var icon: String {
        switch self {
        case .success:
            return "checkmark.circle.fill"
        case .error:
            return "xmark.circle.fill"
        case .info:
            return "info.circle.fill"
        }
    }
}

// MARK: - Toast View
struct ToastView: View {
    let message: String
    let style: ToastStyle
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: style.icon)
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .medium))
            
            Text(message)
                .font(.custom("Rubik", size: 14))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(style.backgroundColor)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 16)
    }
}

// MARK: - Toast Modifier
struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let style: ToastStyle
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                VStack {
                    Spacer()
                    
                    ToastView(message: message, style: style)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isPresented = false
                                }
                            }
                        }
                }
                .animation(.easeInOut(duration: 0.3), value: isPresented)
            }
        }
    }
}

// MARK: - View Extension
extension View {
    func toast(isPresented: Binding<Bool>, message: String, style: ToastStyle) -> some View {
        modifier(ToastModifier(isPresented: isPresented, message: message, style: style))
    }
}

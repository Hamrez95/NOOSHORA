import PartnerDemoApp from "./PartnerDemoApp";
import StorefrontApp from "./StorefrontApp";

export default function HomePage() {
  const demoMode = process.env.NEXT_PUBLIC_NOOSHORA_DEMO_MODE !== "false";
  return demoMode ? <PartnerDemoApp /> : <StorefrontApp />;
}
